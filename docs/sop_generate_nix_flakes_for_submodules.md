# Standard Operating Procedure: Generate Nix Flakes for All Git Submodules

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