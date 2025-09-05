use std::collections::{HashSet, HashMap};
use std::fs::File;
use std::io::{self, BufReader, BufRead};
use walkdir::WalkDir;
use regex::Regex;

fn main() -> io::Result<()> {
    let root_dir = "/data/data/com.termux/files/home/storage/github/";

    let mut local_repo_urls: HashSet<String> = HashSet::new();
    let mut submodule_urls: HashSet<String> = HashSet::new();

    let git_config_regex = Regex::new(r"url\s*=\s*(.*)").unwrap();
    let gitmodules_regex = Regex::new(r"url\s*=\s*(.*)").unwrap();

    // Find and process .git/config files
    for entry in WalkDir::new(root_dir).into_iter().filter_map(|e| e.ok()) {
        if entry.file_name() == "config" && entry.path().ends_with(".git/config") {
            if let Ok(file) = File::open(entry.path()) {
                let reader = BufReader::new(file);
                let mut in_remote_origin_section = false;
                for line in reader.lines() {
                    let line = line?;
                    if line.trim() == "[remote "origin"]" {
                        in_remote_origin_section = true;
                    } else if line.trim().starts_with("[") {
                        in_remote_origin_section = false;
                    }

                    if in_remote_origin_section {
                        if let Some(captures) = git_config_regex.captures(&line) {
                            if let Some(url) = captures.get(1) {
                                local_repo_urls.insert(url.as_str().trim().to_string());
                            }
                        }
                    }
                }
            }
        }
    }

    // Find and process .gitmodules files
    for entry in WalkDir::new(root_dir).into_iter().filter_map(|e| e.ok()) {
        if entry.file_name() == ".gitmodules" {
            if let Ok(file) = File::open(entry.path()) {
                let reader = BufReader::new(file);
                for line in reader.lines() {
                    let line = line?;
                    if let Some(captures) = gitmodules_regex.captures(&line) {
                        if let Some(url) = captures.get(1) {
                            submodule_urls.insert(url.as_str().trim().to_string());
                        }
                    }
                }
            }
        }
    }

    println!("--- Local Git Repository URLs (from .git/config) ---");
    for url in &local_repo_urls {
        println!("{}", url);
    }

    println!("
--- Submodule URLs (from .gitmodules) ---");
    for url in &submodule_urls {
        println!("{}", url);
    }

    println!("
--- Missing Repositories (Local but not Submodule) ---");
    let mut missing_repos: Vec<&String> = local_repo_urls.difference(&submodule_urls).collect();
    missing_repos.sort(); // Sort for consistent output
    for url in missing_repos {
        println!("{}", url);
    }

    Ok(())
}
