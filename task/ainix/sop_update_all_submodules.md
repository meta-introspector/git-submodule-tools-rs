# SOP: Updating All Git Submodules

## 1. Purpose
This Standard Operating Procedure (SOP) outlines the process for updating all Git submodules within the project to their latest committed versions as recorded in the superproject. This ensures that all dependencies are synchronized and up-to-date.

## 2. Scope
This SOP applies to all Git submodules configured in the project's `.gitmodules` file.

## 3. Prerequisites
*   A local clone of the main repository.
*   Git installed and configured.
*   Submodules are already initialized (or will be initialized by the update command).

## 4. Procedure

### 4.1. Updating All Submodules

To update all submodules, including initializing any that haven't been initialized yet, execute the following command from the root of the main repository:

```bash
git submodule update --init --recursive
```

*   **`git submodule update`**: This command updates the registered submodules to match the commit recorded in the superproject.
*   **`--init`**: This option initializes any submodules that have not yet been initialized. This is crucial when cloning a repository with submodules for the first time or when new submodules are added.
*   **`--recursive`**: This option will recurse into all registered submodules and update any nested submodules they might contain.

### 4.2. Verifying Submodule Status

After the update, you can verify the status of all submodules using:

```bash
git submodule status
```

This command will list all submodules, their current commits, and indicate if they are up-to-date with the superproject's recorded commits.

## 5. Troubleshooting

*   **Network issues:** Ensure you have a stable internet connection, as the update process involves fetching data from remote repositories.
*   **Authentication failures:** If a submodule's remote repository requires authentication, ensure your credentials are correctly configured (e.g., SSH keys).
*   **Submodule is "dirty":** If `git status` in the main repository shows a submodule as "dirty" (modified content or new commits), it means there are uncommitted changes within that submodule or it's ahead of the superproject's recorded commit. You should address these changes within the submodule's repository.

## 6. Related Documents
*   `.gitmodules`
*   `git submodule` documentation
