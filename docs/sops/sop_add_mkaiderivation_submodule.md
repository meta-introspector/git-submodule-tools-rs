# SOP: Adding the `mkAIDerivation` Submodule

This Standard Operating Procedure (SOP) outlines the steps to add the `mkAIDerivation` repository as a Git submodule to this project.

## Purpose

To integrate the `mkAIDerivation` project as a submodule, allowing its code to be managed as part of this repository while maintaining its independent version control history.

## Procedure

1.  **Navigate to the Project Root:**
    Ensure you are in the root directory of the main project.

    ```bash
    cd /data/data/com.termux.nix/files/home/pick-up-nix2/source/github/meta-introspector/git-submodule-tools-rs
    ```

2.  **Add the Submodule:**
    Execute the following Git command to add the `mkAIDerivation` repository as a submodule. It will be placed under `vendor/meta-introspector/mkAIDerivation`.

    ```bash
    git submodule add https://github.com/meta-introspector/mkAIDerivation.git vendor/meta-introspector/mkAIDerivation
    ```

    *   `git submodule add`: The command to add a new submodule.
    *   `https://github.com/meta-introspector/mkAIDerivation.git`: The URL of the repository to add.
    *   `vendor/meta-introspector/mkAIDerivation`: The local path where the submodule will be cloned.

3.  **Initialize and Update Submodules:**
    After adding, initialize and update all submodules to ensure the newly added submodule (and any others) are correctly cloned and checked out.

    ```bash
    git submodule update --init --recursive
    ```

4.  **Verify the Submodule:**
    Check the status of your Git repository to confirm the submodule has been added and initialized correctly.

    ```bash
    git status
    git submodule status
    ```

    You should see `vendor/meta-introspector/mkAIDerivation` listed in the output.

5.  **Commit the Changes:**
    Commit the changes to `.gitmodules` and the new submodule entry in your main repository's `.git/config` (which `git submodule add` automatically handles).

    ```bash
    git add .gitmodules vendor/meta-introspector/mkAIDerivation
    git commit -m "Add mkAIDerivation as a submodule under vendor/meta-introspector"
    ```

## Troubleshooting

*   If the submodule directory is not empty, `git submodule add` will fail. Ensure the target directory (`vendor/meta-introspector/mkAIDerivation`) is empty or does not exist before adding.
*   If you encounter issues with cloning, verify your network connection and repository URL.
*   If `git submodule update` fails, ensure you have the necessary permissions to clone the submodule repository.
