# Generating Nix Flakes for Git Submodules

This document outlines the process for generating and managing Nix flakes for Git submodules within the project. These flakes enable standalone and reproducible checkouts and builds of each submodule.

## 1. Initial Flake Generation

The `flake.nix` files for each submodule are generated automatically based on the `.gitmodules` file. These flakes are located in the `submodule-flakes/` directory, with each submodule having its own subdirectory (e.g., `submodule-flakes/vendor_cargo_metadata/flake.nix`).

Each generated `flake.nix` includes placeholders for `submoduleUrl`, `submoduleRev` (commit hash), and `submoduleSha256`. The `submoduleUrl` is pre-filled from `.gitmodules`, but `submoduleRev` and `submoduleSha256` need to be updated.

## 2. Updating Submodule Flakes (Revision and SHA256)

To update the `submoduleRev` and `submoduleSha256` in all generated flakes, use the `update_submodule_flakes.sh` script:

```bash
./update_submodule_flakes.sh
```

This script performs the following actions for each submodule:
1. Reads the submodule's URL from `.gitmodules`.
2. Determines the current commit hash (`rev`) of the submodule.
3. Uses `nix-prefetch-url --unpack <submoduleUrl> <submoduleRev>` to calculate the `sha256` hash.
4. Updates the corresponding `flake.nix` file with the correct `rev` and `sha256`.

**Prerequisites:**
*   `git` must be installed and configured.
*   `nix-prefetch-url` must be available in your PATH.

## 3. Building Submodule Flakes

Once the `flake.nix` files are updated with the correct `rev` and `sha256`, you can build all of them using the `build_all_submodule_flakes.sh` script:

```bash
./build_all_submodule_flakes.sh
```

This script iterates through each submodule's flake directory and runs `nix build .` to build the default package defined in the flake. Upon successful completion, a `result` symlink will be created in each submodule's flake directory, pointing to the fetched submodule in the Nix store.

## 4. Testing Procedure for Individual Flakes

To test a specific submodule flake:

1.  **Navigate to the flake directory:**
    ```bash
    cd /data/data/com.termux.nix/files/home/pick-up-nix2/source/github/meta-introspector/git-submodule-tools-rs/submodule-flakes/<submodule_name_sanitized>
    ```
    (Replace `<submodule_name_sanitized>` with the actual sanitized name, e.g., `vendor_cargo_metadata`)

2.  **Ensure placeholders are updated:** Run `./update_submodule_flakes.sh` from the project root to ensure the `rev` and `sha256` are correct in the `flake.nix` file.

3.  **Build the flake:**
    ```bash
    nix build .
    ```

4.  **Inspect the output:**
    A `result` symlink will be created in the current directory, pointing to the fetched submodule in the Nix store. You can inspect its contents to verify the checkout.

## 5. Future Enhancements

*   **Automated `git submodule update --init --recursive`:** Integrate this command into the update script to ensure local submodules are in sync before generating flakes.
*   **Error Handling:** Improve error handling in the scripts for better robustness.
*   **Custom Build Instructions:** Allow for more customized build instructions within the generated `flake.nix` files, beyond just copying the source.
*   **License Management:** Automatically determine and set the correct license for each submodule.
