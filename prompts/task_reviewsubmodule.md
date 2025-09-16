# Task: Generate Nix Flakes for All Git Submodules

## Objective:
Generate a Nix build expression (flake) for each Git submodule in the project, enabling standalone and reproducible checkouts and builds. This task aims to integrate all submodules into the Nix ecosystem, ensuring their proper management and testing.

## Context:

*   **Nix Environment:**
    *   Main Nix flake: `~/pick-up-nix2/flake.nix`
    *   Rust toolchain flake: `~/pick-up-nix2/vendor/external/rust/src/tools/nix-dev-shell/flake.nix`
*   **Example Submodules:**
    *   `vendor/cargo_metadata`
    *   `vendor/gitoxide`
    *   `vendor/meta-introspector/meta-meme`
    *   `vendor/meta-introspector/meta-meme.wiki`
    *   `vendor/octocrab`
    *   `vendor/zola`

## Task Description:

1.  **Review `.gitmodules`:** Examine the project's `.gitmodules` file to identify all configured Git submodules.
2.  **Generate Nix Flake per Submodule:** For each identified submodule, create a Nix build expression (flake) that performs a standalone Git checkout. This flake should:
    *   Utilize `pkgs.fetchgit` or an equivalent Nix function to fetch the submodule's content.
    *   Include placeholders for `submoduleUrl`, `submoduleRev`, and `submoduleSha256`.
    *   Adhere to the project's principles for modularity, reproducibility, and formal verification (as outlined in other SOPs).
3.  **Integrate with Existing Nix:** Ensure the generated flakes can be integrated with the existing Nix environment, potentially by adding them to the main `flake.nix` or creating a dedicated `llm-nix/flake.nix` for these generated expressions.
4.  **Develop Management Scripts:** Create shell scripts to automate the process of:
    *   Updating `submoduleUrl` and `submoduleRev` in the generated flakes.
    *   Performing the initial Nix build to discover the `sha256` hash.
    *   Updating the `sha256` hash in the flakes.
    *   Executing the final Nix build.

## Deliverables:

*   A set of Nix flakes, one for each Git submodule, enabling standalone checkouts.
*   Shell scripts to automate the management and building of these submodule flakes.
*   Documentation (SOPs) for the process of generating and managing these flakes.


To use the generated Nix build expression and the accompanying shell script, follow these steps:

1.  **Navigate to the directory:**
    ```bash
    cd /data/data/com.termux.nix/files/home/pick-up-nix2/source/github/meta-introspector/git-submodule-tools-rs/submodule-checkout2/
    ```

2.  **Run the update script:**
    Execute the `update_submodule_flake.sh` script with the desired submodule URL and revision. For example, to check out a specific revision of `nixpkgs`:
    ```bash
    ./update_submodule_flake.sh https://github.com/NixOS/nixpkgs 1234567890abcdef1234567890abcdef12
    ```
    (Replace `https://github.com/NixOS/nixpkgs` and `1234567890abcdef1234567890abcdef12` with the actual URL and commit hash of your target submodule.)

    This script will:
    *   Update the `submoduleUrl` and `submoduleRev` in `flake.nix`.
    *   Attempt an initial `nix-build`, which will fail and report the correct `sha256` hash.
    *   Automatically update the `sha256` in `flake.nix` with the discovered value.
    *   Perform a final `nix-build` to verify the successful checkout.

3.  **Access the checked-out submodule:**
    Upon successful completion, the submodule will be checked out into the Nix store. The script will print the path to the checked-out content, which will also be symlinked to `./result` in the current directory (though the script cleans up this symlink after printing the path).
