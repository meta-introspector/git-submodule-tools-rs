use bstr::ByteSlice;
use gix_config::File as GixConfigFile;
use std::collections::HashSet;
use std::io;
use std::path::Path;

fn main() -> io::Result<()> {
    let root_dir = Path::new("/data/data/com.termux/files/home/storage/github/");

    let mut local_repo_urls: HashSet<String> = HashSet::new();
    let mut submodule_urls: HashSet<String> = HashSet::new();

    // Find and process .git/config files using gix-discover and gix-config
    let config_content;
    if let Ok((repo_path, _trust)) = gix_discover::upwards(root_dir) {
        let git_dir = repo_path.as_ref().join(".git");
        let config_path = git_dir.join("config");

        if config_path.exists() {
            config_content = std::fs::read(&config_path)?;
            if let Ok(config) = GixConfigFile::try_from(config_content.as_bstr()) {
                if let Some(url_value) =
                    config.string_by("remote", Some(b"origin".as_bstr()), "url")
                {
                    local_repo_urls.insert(url_value.to_string());
                }
            }
        }
    }

    // Find and process .gitmodules files using gix-config
    let gitmodules_content;
    if let Ok((repo_path, _trust)) = gix_discover::upwards(root_dir) {
        let gitmodules_path = repo_path.as_ref().join(".gitmodules");

        if gitmodules_path.exists() {
            gitmodules_content = std::fs::read(&gitmodules_path)?;
            if let Ok(config) = GixConfigFile::try_from(gitmodules_content.as_bstr()) {
                if let Some(urls) = config.strings_by("submodule", None, "url") {
                    for url_value in urls {
                        submodule_urls.insert(url_value.to_string());
                    }
                }
            }
        }
    }

    println!("--- Local Git Repository URLs (from .git/config) ---");
    for url in &local_repo_urls {
        println!("{}", url);
    }

    println!("\n--- Submodule URLs (from .gitmodules) ---");
    for url in &submodule_urls {
        println!("{}", url);
    }

    println!("\n--- Missing Repositories (Local but not Submodule) ---");
    let mut missing_repos: Vec<&String> = local_repo_urls.difference(&submodule_urls).collect();
    missing_repos.sort(); // Sort for consistent output
    for url in missing_repos {
        println!("{}", url);
    }

    Ok(())
}
