use anyhow::{Result, Context};
use gix::object::tree::EntryMode;
use gix::remote::Direction;
use gix::Repository;
use std::{fs, path::PathBuf};

fn main() -> Result<()> {
    let zos_vector = vec![0, 1, 2, 3, 5, 7, 11, 13, 17, 19, 23];
    let repo_path = PathBuf::from("."); // Current directory
    let mut repo = gix::open(repo_path)
        .context("Failed to open repository")?;

    let remote_name = "origin"; // Assuming 'origin' is the remote
    let mut remote = repo.find_remote(remote_name)?;

    for n in zos_vector {
        let branch_name = format!("zos-seed-{}", n);
        let seed_file_name = format!("seed_{}.txt", n);
        let seed_file_content = format!("This is the seed file for zos-seed-{} branch.\n", n);

        // Create an orphaned branch
        let (mut branch, _) = repo
            .branch_and_checkout_orphan(&branch_name, "HEAD", &mut gix::progress::Discard)
            .context(format!("Failed to create orphan branch {}", branch_name))?;

        // Write the seed file
        let repo_root = repo.work_dir().context("Repository has no workdir")?;
        let seed_file_path = repo_root.join(&seed_file_name);
        fs::write(&seed_file_path, seed_file_content.as_bytes())
            .context(format!("Failed to write seed file {}", seed_file_name))?;

        // Add the file to the index
        let relative_path = seed_file_path.strip_prefix(repo_root)?;
        let mut index = repo.index_mut()?;
        index.add_path(relative_path, EntryMode::FILE, &mut gix::progress::Discard)?;
        let tree_id = index.write_tree()?;
        index.write()?;

        // Create a commit
        let committer = repo.committer().context("Failed to get committer")?;
        let signature = committer.to_signature()?;
        let commit_id = repo
            .commit(
                "HEAD",
                &signature,
                &signature,
                &format!("Initialize zos-seed-{} branch", n),
                tree_id,
                None, // No parents for the first commit on an orphan branch
            )
            .context("Failed to create commit")?;

        // Update the branch reference to point to the new commit
        let mut head = repo.head()?;
        head.set_target(commit_id, "initializing zos-seed branch")?;

        // Push the branch to the remote
        remote
            .push_setup(Direction::Push, &branch_name, &branch_name)
            .context("Failed to set up push")?;
        remote
            .push(&mut gix::progress::Discard, None)
            .context(format!("Failed to push branch {}", branch_name))?;

        println!("Successfully created and pushed branch: {}", branch_name);
    }

    Ok(())
}