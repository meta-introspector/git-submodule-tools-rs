use anyhow::{Context, Result};
use clap::Parser;
use serde::{Deserialize, Serialize};
use std::fs::File;
use std::io::{self, BufRead, Write};
use std::path::{Path, PathBuf};
use walkdir::WalkDir;
use git2::Repository;
use url::Url;

mod config;
use config::Config;

#[derive(Parser, Debug)]
#[command(author, version, about, long_about = None)]
struct Args {
    /// Path to the input file containing a list of file paths.
    #[arg(short, long)]
    input_file: PathBuf,

    /// Path to the output file for newer files (optional).
    #[arg(short, long)]
    output_file: Option<PathBuf>,

    /// Path to the configuration file (optional).
    #[arg(short, long)]
    config_file: Option<PathBuf>,
}

#[derive(Debug, Deserialize, Serialize)]
struct Package {
    name: String,
    version: String,
    authors: Option<Vec<String>>,
}

#[derive(Debug, Deserialize, Serialize)]
struct CargoToml {
    package: Package,
}

#[derive(Debug, Serialize)]
struct CrateInfo {
    package_name: String,
    version: String,
    authors: Option<Vec<String>>,
    cargo_toml_path: PathBuf,
    relative_path: PathBuf,
    git_repo_root: Option<PathBuf>,
    git_org: Option<String>,
    git_repo_name: Option<String>,
    modified_date: Option<String>,
}

fn main() -> Result<()> {
    let args = Args::parse();

    let config = if let Some(config_path) = &args.config_file {
        Config::new().with_context(|| format!("Failed to load config from {:?}", config_path))?
    } else {
        Config::new().context("Failed to load default config")?
    };

    let mut log_file: Option<File> = None;
    if let Some(log_path) = &config.log_file {
        log_file = Some(File::create(log_path).context("Failed to create log file")?);
    }

    let mut log_message = |message: &str| {
        if let Some(file) = &mut log_file {
            writeln!(file, "{}", message).unwrap_or_else(|e| eprintln!("Failed to write to log file: {}", e));
        }
    };

    println!("Crate Indexer started.");
    log_message(&format!("Crate Indexer started. Input file: {:?}", args.input_file));

    let file = File::open(&args.input_file)
        .with_context(|| format!("Could not open input file {:?}\n", args.input_file))?;
    let reader = io::BufReader::new(file);

    let mut all_crate_info: Vec<CrateInfo> = Vec::new();
    let project_root = std::env::current_dir().context("Failed to get current directory")?;

    for line in reader.lines() {
        let file_path_str = line.with_context(|| "Failed to read line from input file")?;
        let path = PathBuf::from(file_path_str);

        if path.is_dir() {
            for entry in WalkDir::new(&path)
                .into_iter()
                .filter_map(|e| e.ok())
                .filter(|e| e.file_name() == "Cargo.toml")
            {
                let cargo_toml_path = entry.path().to_path_buf();
                match extract_crate_info(&cargo_toml_path, &project_root, &config) { // Pass config
                    Ok(Some(info)) => all_crate_info.push(info),
                    Ok(None) => {}, // Skipped
                    Err(e) => {
                        log_message(&format!("Error processing {}: {}", cargo_toml_path.display(), e));
                        eprintln!("Error processing {}: {}", cargo_toml_path.display(), e); // Still print critical errors to stderr
                    }
                }
            }
        } else if path.file_name().map_or(false, |name| name == "Cargo.toml") {
            match extract_crate_info(&path, &project_root, &config) { // Pass config
                Ok(Some(info)) => all_crate_info.push(info),
                Ok(None) => {}, // Skipped
                Err(e) => {
                    log_message(&format!("Error processing {}: {}", path.display(), e));
                    eprintln!("Error processing {}: {}", path.display(), e); // Still print critical errors to stderr
                }
            }
        } else {
            // If it's a file but not Cargo.toml, just skip it silently.
            // The user wants `find` to find all files, and `crate_indexer` to filter.
            log_message(&format!("Skipping non-Cargo.toml file: {:?}", path));
        }
    }

    let json_output = serde_json::to_string_pretty(&all_crate_info)?;

    if let Some(output_file_path) = args.output_file {
        std::fs::write(&output_file_path, json_output)
            .with_context(|| format!("Could not write to output file {:?}", output_file_path))?;
        println!("\n--- Extracted Crate Information written to {:?} ---", output_file_path);
        log_message(&format!("Extracted Crate Information written to {:?}", output_file_path));
    } else {
        println!("\n--- Extracted Crate Information (JSON) ---");
        println!("{}", json_output);
        log_message("Extracted Crate Information printed to stdout.");
    }

    println!("\nCrate Indexer finished.");
    log_message("Crate Indexer finished.");

    Ok(())
}

fn extract_crate_info(cargo_toml_path: &Path, project_root: &Path, config: &Config) -> Result<Option<CrateInfo>> {
    let content = std::fs::read_to_string(cargo_toml_path)
        .with_context(|| format!("Could not read {:?}", cargo_toml_path))?;

    let cargo_toml: CargoToml = match toml::from_str(&content) {
        Ok(toml) => toml,
        Err(e) => {
            if config.error_suppression.skip_malformed_toml {
                eprintln!("  Skipping malformed Cargo.toml: {:?} - Error: {}", cargo_toml_path, e);
                return Ok(None);
            } else {
                return Err(e).context(format!("Could not parse Cargo.toml at {:?}", cargo_toml_path));
            }
        }
    };

    let relative_path = cargo_toml_path.strip_prefix(project_root)
        .unwrap_or(cargo_toml_path) // Fallback if not under project_root
        .to_path_buf();

    let modified_date = if let Ok(metadata) = std::fs::metadata(cargo_toml_path) {
        if let Ok(time) = metadata.modified() {
            Some(format!("{:?}", time)) // Format as needed
        } else {
            None
        }
    } else {
        None
    };

    let mut git_repo_root: Option<PathBuf> = None;
    let mut git_org: Option<String> = None;
    let mut git_repo_name: Option<String> = None;

    if let Ok(repo) = Repository::discover(cargo_toml_path) {
        git_repo_root = Some(repo.path().parent().unwrap_or(repo.path()).to_path_buf());
        if let Ok(remote) = repo.find_remote("origin") {
            if let Some(url_str) = remote.url() {
                if let Ok(parsed_url) = Url::parse(url_str) {
                    let path_segments: Vec<&str> = parsed_url.path_segments().map_or(Vec::new(), |s| s.collect());
                    if path_segments.len() >= 2 {
                        git_repo_name = Some(path_segments.last().unwrap().trim_end_matches(".git").to_string());
                        git_org = Some(path_segments[path_segments.len() - 2].to_string());
                    }
                }
            }
        }
    }

    Ok(Some(CrateInfo {
        package_name: cargo_toml.package.name,
        version: cargo_toml.package.version,
        authors: cargo_toml.package.authors,
        cargo_toml_path: cargo_toml_path.to_path_buf(),
        relative_path,
        git_repo_root,
        git_org,
        git_repo_name,
        modified_date,
    }))
}