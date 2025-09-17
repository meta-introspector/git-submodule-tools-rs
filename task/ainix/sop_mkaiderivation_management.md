# SOP: mkAIDerivation Submodule Management

## 1. Purpose
This Standard Operating Procedure (SOP) outlines the process for managing the `mkAIDerivation` Git submodule within the project. This includes initialization, updating, and basic interaction with the submodule's content.

## 2. Scope
This SOP applies to all developers and contributors working with the `mkAIDerivation` submodule.

## 3. Prerequisites
*   A local clone of the main repository.
*   Git installed and configured.
*   The `mkAIDerivation` submodule entry exists in the project's `.gitmodules` file.

## 4. Procedure

### 4.1. Initializing and Updating the `mkAIDerivation` Submodule

To ensure the `mkAIDerivation` submodule is present and up-to-date, execute the following command from the root of the main repository:

```bash
git submodule update --init --recursive vendor/mkAIDerivation
```

*   **`git submodule update`**: This command updates the registered submodules to match the commit recorded in the superproject.
*   **`--init`**: This option initializes any submodules that have not yet been initialized. A submodule is initialized once when you first clone the superproject with `--recurse-submodules` or run `git submodule update --init`.
*   **`--recursive`**: This option will recurse into the registered submodules and update any nested submodules within `mkAIDerivation`.
*   **`vendor/mkAIDerivation`**: Specifies that only this particular submodule should be updated.

### 4.2. Verifying Submodule Status

After initialization or update, you can verify the status of the `mkAIDerivation` submodule using:

```bash
git submodule status vendor/mkAIDerivation
```

This command will show the current commit of the submodule and indicate if it's up-to-date with the superproject's recorded commit.

### 4.3. Navigating into the Submodule

To work directly within the `mkAIDerivation` submodule's repository, navigate into its directory:

```bash
cd vendor/mkAIDerivation
```

From within this directory, you can perform standard Git operations (e.g., `git pull`, `git checkout`, `git log`) specific to the `mkAIDerivation` repository.

### 4.4. Returning to the Main Repository

To return to the root of the main repository, use:

```bash
cd -
```
or
```bash
cd ../.. # If you are in vendor/mkAIDerivation
```

## 5. Troubleshooting

*   **Submodule directory not found:** If `vendor/mkAIDerivation` does not exist after running `git submodule update --init --recursive vendor/mkAIDerivation`, ensure that the `.gitmodules` file correctly lists the submodule and its path.
*   **Submodule is "dirty":** If `git status` in the main repository shows the submodule as "dirty" (modified content or new commits), it means there are uncommitted changes within the submodule or it's ahead of the superproject's recorded commit. You should either commit those changes within the submodule and push them, or update the superproject to reflect the submodule's new state.

## 6. Related Documents
*   `.gitmodules`
*   `git submodule` documentation
