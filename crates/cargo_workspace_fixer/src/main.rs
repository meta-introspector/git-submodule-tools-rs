use clap::Parser;
use std::process::{Command, Stdio};
use std::path::{Path, PathBuf};
use walkdir::WalkDir;
use gix_config::File as GixConfigFile;
use bstr::ByteSlice;
use std::fs;
use std::ffi::OsStr;
use toml::Value;

#[derive(Parser, Debug)]
#[clap(author, version, about, long_about = None)]
struct Args {
    /// The root directory to analyze and generate a workspace for.
    #[clap(long, default_value = ".")]
    root_dir: String,
    /// Apply automatic fixes to the code.
    #[clap(long)]
    fix: bool,
    /// Format the code.
    #[clap(long)]
    fmt: bool,
    /// Run clippy linter.
    #[clap(long)]
    clippy: bool,
}

fn run_command(cmd: &str, args: &[&str]) -> Result<(), String> {
    println!("Running: {} {}", cmd, args.join(" "));
    let output = Command::new(cmd)
        .args(args)
        .stdout(Stdio::inherit())
        .stderr(Stdio::inherit())
        .output()
        .map_err(|e| format!("Failed to execute command '{}': {}", cmd, e))?;

    if output.status.success() {
        Ok(())
    } else {
        Err(format!("Command '{}' failed with exit code: {:?}", cmd, output.status.code()))
    }
}

fn find_rust_crates(root_dir: &Path) -> Vec<PathBuf> {
    let mut crate_paths = Vec::new();
    for entry in WalkDir::new(root_dir).into_iter().filter_map(|e| e.ok()) {
        if entry.file_name() == "Cargo.toml" {
            if let Some(parent) = entry.path().parent() {
                crate_paths.push(parent.to_path_buf());
            }
        }
    }
    crate_paths
}

fn find_rust_crates_in_submodules(root_dir: &Path) -> Vec<PathBuf> {
    let mut submodule_crate_paths = Vec::new();
    let gitmodules_path = root_dir.join(".gitmodules");

    if gitmodules_path.exists() {
        let gitmodules_content = std::fs::read(&gitmodules_path).expect("Failed to read .gitmodules");
        if let Ok(config) = GixConfigFile::try_from(gitmodules_content.as_bstr()) {
            if let Some(submodule_paths) = config.strings_by("submodule", None, "path") {
                for submodule_path_str in submodule_paths {
                    let submodule_abs_path = root_dir.join(submodule_path_str.to_string());
                    let cargo_toml_path = submodule_abs_path.join("Cargo.toml");
                    if cargo_toml_path.exists() {
                        submodule_crate_paths.push(submodule_abs_path);
                    }
                }
            }
        }
    }
    submodule_crate_paths
}

fn aggregate_lints(crate_paths: &[PathBuf]) -> Value {
    let mut aggregated_lints = toml::Table::new();

    for p in crate_paths {
        let cargo_toml_path = p.join("Cargo.toml");
        if cargo_toml_path.exists() {
            let content = fs::read_to_string(&cargo_toml_path).expect("Failed to read Cargo.toml");
            let parsed_toml: Value = content.parse().expect("Failed to parse Cargo.toml");

            if let Some(package_table) = parsed_toml.get("package").and_then(|v| v.as_table()) {
                if let Some(lints_table) = package_table.get("lints").and_then(|v| v.as_table()) {
                    for (key, value) in lints_table {
                        // For simplicity, just insert. A more robust solution would handle conflicts.
                        aggregated_lints.insert(key.clone(), value.clone());
                    }
                }
            }
        }
    }
    Value::Table(aggregated_lints)
}

fn generate_workspace_cargo_toml(root_dir: &Path, all_rust_crates: &[PathBuf], lints: &Value) -> Result<(), Box<dyn std::error::Error>> {
    let workspace_name = root_dir.file_name().unwrap_or(OsStr::new("default")).to_string_lossy().to_string();
    let workspace_dir = PathBuf::from("workspaces").join(workspace_name);
    fs::create_dir_all(&workspace_dir)?;

    let cargo_toml_path = workspace_dir.join("Cargo.toml");

    let members_list_formatted: Vec<String> = all_rust_crates.iter().map(|p| {
        let relative_path = pathdiff::diff_paths(p, &workspace_dir).expect("Failed to calculate relative path");
        format!("    \"{}\"", relative_path.display())
    }).collect();

    let mut cargo_toml_content = format!(
        "[workspace]\nmembers = [\n{}\n]\n",
        members_list_formatted.join(",\n")
    );

    if let Some(lints_table) = lints.as_table() {
        if !lints_table.is_empty() {
            cargo_toml_content.push_str("\n[workspace.lints]\n");
            cargo_toml_content.push_str(&toml::to_string_pretty(lints_table)?);
        }
    }

    fs::write(&cargo_toml_path, cargo_toml_content)?;
    println!("Generated workspace Cargo.toml at: {}", cargo_toml_path.display());

    Ok(())
}

fn main() -> Result<(), Box<dyn std::error::Error>> {
    let args = Args::parse();

    let root_path = PathBuf::from(&args.root_dir);
    let mut all_rust_crates = find_rust_crates(&root_path);
    let submodule_crates = find_rust_crates_in_submodules(&root_path);
    all_rust_crates.extend(submodule_crates);

    // Filter out the root_path itself if it's a crate, as it will be the workspace root
    all_rust_crates.retain(|p| p != &root_path);

    let aggregated_lints = aggregate_lints(&all_rust_crates);

    generate_workspace_cargo_toml(&root_path, &all_rust_crates, &aggregated_lints)?;

    println!("Found Rust crates:");
    for p in all_rust_crates {
        println!("{}", p.display());
    }

    if args.fix {
        run_command("cargo", &["fix", "--workspace", "--allow-dirty"])?;
    }

    if args.fmt {
        run_command("cargo", &["fmt", "--all"])?;
    }

    if args.clippy {
        run_command("cargo", &["clippy", "--workspace", "--all-targets", "--all-features", "--", "-D", "warnings"])?;
    }

    if !args.fix && !args.fmt && !args.clippy {
        println!("No actions specified. Use --fix, --fmt, or --clippy.");
    }

    Ok(())
}
