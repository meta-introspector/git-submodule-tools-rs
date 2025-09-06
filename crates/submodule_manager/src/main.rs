use anyhow::{Context, Result};
use clap::Parser;
use gix::bstr::ByteSlice;
use gix::config::File as GixConfigFile;
use std::path::{Path, PathBuf};
use std::process::{Command, Stdio};

#[derive(Parser, Debug)]
#[command(author, version, about, long_about = None)]
struct Args {
    /// The commit message to use for submodule and superproject commits.
    #[arg(short, long)]
    message: String,

    /// Perform a dry run without making any changes.
    #[arg(short, long, default_value_t = false)]
    dry_run: bool,

    /// Push changes to remotes after committing.
    #[arg(short, long, default_value_t = false)]
    push: bool,
}

fn main() -> Result<()> {
    let args = Args::parse();

    println!("Submodule Manager started.");
    println!("Commit Message: {}", args.message);
    println!("Dry Run: {}", args.dry_run);
    println!("Push: {}", args.push);

    let superproject_root = find_git_superproject_root().context("Could not find git superproject root")?;
    println!("Superproject root: {:?}", superproject_root);

    let gitmodules_path = superproject_root.join(".gitmodules");
    if !gitmodules_path.exists() {
        println!("No .gitmodules file found. Exiting.");
        return Ok(());
    }

    let gitmodules_content = std::fs::read(&gitmodules_path)
        .with_context(|| format!("Could not read {:?}", gitmodules_path))?;
    let gitmodules_config = GixConfigFile::try_from(gitmodules_content.as_bstr())
        .context("Could not parse .gitmodules file")?;

    let mut submodules_to_process = Vec::new();
    if let Some(submodule_sections) = gitmodules_config.sections_by_name("submodule") {
        for section in submodule_sections {
            if let Some(path_bstr) = section.value("path") {
                submodules_to_process.push(path_bstr.to_string());
            }
        }
    }

    println!("\nFound {} submodules:", submodules_to_process.len());
    for submodule_path_str in submodules_to_process {
        let submodule_path = superproject_root.join(&submodule_path_str);
        println!("Processing submodule: {:?}", submodule_path);

        // Process submodule
        process_submodule(&submodule_path, &args, &superproject_root)
            .with_context(|| format!("Failed to process submodule {:?}", submodule_path))?;
    }

    // Process superproject
    println!("\nProcessing superproject: {:?}", superproject_root);
    process_superproject(&superproject_root, &args)
        .context("Failed to process superproject")?;

    println!("\nSubmodule Manager finished.");

    Ok(())
}

fn find_git_superproject_root() -> Result<PathBuf> {
    let output = Command::new("git")
        .arg("rev-parse")
        .arg("--show-toplevel")
        .stdout(Stdio::piped())
        .spawn()? 
        .wait_with_output()?;

    if !output.status.success() {
        anyhow::bail!("git rev-parse --show-toplevel failed: {}", String::from_utf8_lossy(&output.stderr));
    }

    let path = String::from_utf8_lossy(&output.stdout).trim().to_string();
    Ok(PathBuf::from(path))
}

fn run_git_command(cwd: &Path, args: &[&str], dry_run: bool) -> Result<()> {
    println!("  Running git {:?} in {:?}", args, cwd);
    if dry_run {
        println!("  (Dry run, skipping command execution)");
        return Ok(());
    }

    let output = Command::new("git")
        .current_dir(cwd)
        .args(args)
        .stdout(Stdio::piped())
        .stderr(Stdio::piped())
        .spawn()? 
        .wait_with_output()?;

    if !output.status.success() {
        anyhow::bail!(
            "git {:?} failed in {:?}:\nStdout: {}\nStderr: {}",
            args,
            cwd,
            String::from_utf8_lossy(&output.stdout),
            String::from_utf8_lossy(&output.stderr)
        );
    }

    Ok(())
}

fn process_submodule(submodule_path: &Path, args: &Args, superproject_root: &Path) -> Result<()> {
    let submodule_name = submodule_path.strip_prefix(superproject_root)
        .unwrap_or(submodule_path)
        .display()
        .to_string();

    println!("  Processing submodule: {}", submodule_name);

    // Check if it's a git repository
    let is_git_repo_output = Command::new("git")
        .current_dir(submodule_path)
        .arg("rev-parse")
        .arg("--is-inside-work-tree")
        .stdout(Stdio::piped())
        .stderr(Stdio::piped())
        .spawn()? 
        .wait_with_output()?;

    if !is_git_repo_output.status.success() || String::from_utf8_lossy(&is_git_repo_output.stdout).trim() != "true" {
        println!("  {} is not a git repository. Skipping.", submodule_name);
        return Ok(());
    }

    // Add all changes in submodule
    run_git_command(submodule_path, &["add", "."], args.dry_run)?;

    // Commit changes in submodule
    let commit_message = format!("{} (submodule: {})", args.message, submodule_name);
    let commit_result = run_git_command(submodule_path, &["commit", "-m", &commit_message], args.dry_run);

    // Check if commit actually happened (e.g., not "nothing to commit")
    if let Err(e) = &commit_result {
        if e.to_string().contains("nothing to commit") {
            println!("  No new changes to commit in submodule {}.", submodule_name);
        } else {
            return commit_result; // Propagate other errors
        }
    } else {
        println!("  Committed changes in submodule {}.", submodule_name);
    }

    // Push changes if enabled
    if args.push {
        println!("  Pushing submodule {}...", submodule_name);
        run_git_command(submodule_path, &["push"], args.dry_run)?;
    }

    Ok(())
}

fn process_superproject(superproject_root: &Path, args: &Args) -> Result<()> {
    // Check for changes in superproject (submodule commit updates)
    let status_output = Command::new("git")
        .current_dir(superproject_root)
        .arg("status")
        .arg("--porcelain")
        .stdout(Stdio::piped())
        .stderr(Stdio::piped())
        .spawn()? 
        .wait_with_output()?;

    let status = String::from_utf8_lossy(&status_output.stdout);
    if status.trim().is_empty() {
        println!("No changes in superproject. Skipping.");
        return Ok(());
    }

    println!("Changes detected in superproject. Committing...");

    // Add all changes (including submodule updates)
    run_git_command(superproject_root, &["add", "."], args.dry_run)?;

    // Commit changes
    let commit_message = format!("{} (superproject update)", args.message);
    run_git_command(superproject_root, &["commit", "-m", &commit_message], args.dry_run)?;

    // Push changes if enabled
    if args.push {
        println!("Pushing superproject...");
        run_git_command(superproject_root, &["push"], args.dry_run)?;
    }

    Ok(())
}