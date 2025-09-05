use cargo_metadata::MetadataCommand;

fn main() -> Result<(), Box<dyn std::error::Error>> {
    let metadata = MetadataCommand::new().exec()?;

    let workspace_members: Vec<String> = metadata
        .workspace_members
        .iter()
        .map(|id| id.repr.split_once(' ').unwrap().0.to_string())
        .collect();

    for package in metadata.packages {
        // Skip workspace members as they are not external dependencies to be vendored
        if workspace_members.contains(&package.name) {
            continue;
        }

        if let Some(source) = package.source {
            // Handle git dependencies
            if source.repr.starts_with("git+") {
                let url_str = source.repr.trim_start_matches("git+");
                // Remove any rev=... or #branch=... from the URL
                let url_parts: Vec<&str> = url_str.split('#').collect();
                let clean_url = url_parts[0];

                let path_in_vendor = format!("vendor/{}", package.name);
                println!("git submodule add {} {}", clean_url, path_in_vendor);
            }
            // TODO: Handle registry dependencies (crates.io) - this is more complex as it requires fetching the repo URL
            // For now, we only process git dependencies.
        }
    }

    Ok(())
}
