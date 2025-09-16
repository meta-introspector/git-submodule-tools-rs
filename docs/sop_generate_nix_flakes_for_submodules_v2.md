# Standard Operating Procedure: Generate Nix Flakes for All Git Submodules (Version 2)

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
    *   The flake should be structured as a proper Nix flake with `inputs` (pinning `nixpkgs` to a stable version) and `outputs`.
    *   Include comprehensive `meta` section for documentation.
3.  **Develop Management Scripts:** Create shell scripts to automate the process of:
    *   Updating `submoduleUrl` and `submoduleRev` in the generated flakes.
    *   Performing the initial Nix build to discover the `sha256` hash (using `nix-prefetch-url`).
    *   Updating the `sha256` hash in the flakes.
    *   Executing the final Nix build.
4.  **Testing Procedure:** Define a clear testing procedure for each generated flake, including steps to:
    *   Navigate to the flake directory.
    *   Update placeholders for `submoduleUrl` and `submoduleRev`.
    *   Obtain the correct `submoduleSha256` using `nix-prefetch-url`.
    *   Build the flake using `nix build .`.
    *   Inspect the output in the `result` symlink.

## Deliverables:

*   A set of Nix flakes, one for each Git submodule, enabling standalone checkouts.
*   Shell scripts to automate the management and building of these submodule flakes.
*   Documentation (SOPs) for the process of generating and managing these flakes, including detailed testing instructions.

## Testing Procedure:

To test this `flake.nix`, you need to perform the following steps:

1.  **Navigate to the flake directory:**
    ```bash
    cd /data/data/com.termux.nix/files/home/pick-up-nix2/source/github/meta-introspector/git-submodule-tools-rs/submodule-checkout/
    ```

2.  **Update the placeholders in `flake.nix`:**
    *   Open `flake.nix` and replace `submoduleUrl` and `submoduleRev` with the actual URL and commit hash of your desired submodule.
    *   **Obtain the correct `submoduleSha256`:** Run the following command, replacing `<submoduleUrl>` and `<submoduleRev>` with your values:
        ```bash
        nix-prefetch-url --unpack <submoduleUrl> <submoduleRev>
        ```
        Then, update the `submoduleSha256` in `flake.nix` with the output of this command.

3.  **Build the flake:**
    ```bash
    nix build .
    ```
    (This will build the default package defined in the flake.)

4.  **Inspect the output:**
    Upon successful completion, a `result` symlink will be created in your current directory, pointing to the fetched submodule in the Nix store. You can then inspect its contents to verify the checkout.