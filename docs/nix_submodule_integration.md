# Nix Flake Integration for Git Submodules

This document outlines the process for integrating Git submodules into Nix flakes, ensuring reproducibility and streamlined dependency management. The approach involves generating a dedicated Nix flake for each submodule, which then pins the submodule to a specific revision and its corresponding SHA256 hash.

## Principles

*   **Reproducibility:** Each submodule's content is fetched and pinned using `pkgs.fetchgit` with a precise revision (`rev`) and a cryptographic hash (`sha256`). This guarantees that builds are consistent across different environments and over time.
*   **Modularity:** Each submodule is represented by its own Nix flake, promoting a modular and organized approach to managing external dependencies.
*   **Automation:** The process of generating and updating these flakes can be automated, reducing manual effort and potential for errors.

## Process

The integration process involves the following steps:

1.  **Identify Submodules:**
    List all submodules in your project by inspecting the `.gitmodules` file. For each submodule, note its path and URL.

    Example `.gitmodules` entry:
    ```ini
    [submodule "vendor/my-submodule"]
        path = vendor/my-submodule
        url = https://github.com/example/my-submodule.git
    ```

2.  **Generate Submodule Flake (if not already generated):**
    For each submodule, a `flake.nix` file is generated in the `submodule-flakes-generated/` directory. This flake uses `pkgs.fetchgit` to fetch the submodule's content. Initially, the `submoduleRev` and `submoduleSha256` will be placeholders.

    Example generated `flake.nix` (e.g., `submodule-flakes-generated/my-submodule/flake.nix`):
    ```nix
    {
      description = "Nix flake for my-submodule";

      inputs = {
        nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
      };

      outputs = { self, nixpkgs }:{
        let
          system = "x86_64-linux";
          pkgs = import nixpkgs {
            inherit system;
          };
          submoduleUrl = "https://github.com/example/my-submodule.git";
          submoduleRev = ""; # Placeholder
          submoduleSha256 = "sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA="; # Placeholder
        in {
          packages.${system}.default = pkgs.stdenv.mkDerivation {
            pname = "my-submodule";
            version = "0.1.0";

            src = pkgs.fetchgit {
              url = submoduleUrl;
              rev = submoduleRev;
              sha256 = submoduleSha256;
            };

            buildPhase = "echo 'Submodule my-submodule fetched successfully.'";

            installPhase = "mkdir -p $out/share/my-submodule && cp -r $src/* $out/share/my-submodule";
          };
        };
    }
    ```

3.  **Determine Submodule Revision (Rev):**
    To get the exact commit hash (revision) of a submodule, navigate to the root of the main repository and use the `git submodule status` command.

    ```bash
    cd /path/to/main/repo
    git submodule status vendor/my-submodule
    ```
    The output will provide the commit hash, e.g.:
    `abcdef1234567890abcdef1234567890abcdef12 vendor/my-submodule (v1.0.0-123-gabcdef12)`
    The `abcdef1234567890abcdef1234567890abcdef12` is the `submoduleRev`.

4.  **Obtain Submodule SHA256:**
    Use `nix-prefetch-git` to calculate the `sha256` hash for the submodule's URL and revision. This command should be run in a Nix shell where `nix-prefetch-git` is available.

    ```bash
    nix-shell -p nix-prefetch-git --run "nix-prefetch-git --url https://github.com/example/my-submodule.git --rev abcdef1234567890abcdef1234567890abcdef12"
    ```
    The output will include a JSON object containing the `sha256` hash.

5.  **Update Submodule Flake:**
    Edit the generated `flake.nix` file for the specific submodule (e.g., `submodule-flakes-generated/my-submodule/flake.nix`) and replace the placeholder `submoduleRev` and `submoduleSha256` values with the actual values obtained in the previous steps.

    ```nix
    # ...
          submoduleRev = "abcdef1234567890abcdef1234567890abcdef12";
          submoduleSha256 = "sha256-YOUR_ACTUAL_SHA256_HASH_HERE=";
    # ...
    ```

6.  **Integrate into Main Flake (Optional):**
    Once the individual submodule flakes are correctly configured, they can be easily integrated into a main `flake.nix` file as inputs, allowing the entire project's dependencies, including submodules, to be managed by Nix.

    ```nix
    # In your main flake.nix
    {
      inputs = {
        # ... other inputs
        my-submodule.url = "./submodule-flakes-generated/my-submodule";
      };

      outputs = { self, nixpkgs, my-submodule, ... }:{
        # ...
        packages.${system}.my-submodule-src = my-submodule.packages.${system}.default;
        # ...
      };
    }
    ```

## Example Walkthrough (using `cargo_metadata`)

This section demonstrates the process using the `cargo_metadata` submodule.

1.  **Submodule Information:**
    *   Path: `vendor/cargo_metadata`
    *   URL: `https://github.com/oli-obk/cargo_metadata`

2.  **Get Submodule Revision:**
    ```bash
    bash -c "cd /data/data/com.termux.nix/files/home/pick-up-nix2/source/github/meta-introspector/git-submodule-tools-rs && git submodule status vendor/cargo_metadata"
    # Output: f0df5d0d220c0625cfa1a624ae7cc3d3ac25e31f vendor/cargo_metadata (v0.15.1-161-gf0df5d0)
    ```
    `submoduleRev = "f0df5d0d220c0625cfa1a624ae7cc3d3ac25e31f";`

3.  **Get Submodule SHA256:**
    ```bash
    nix-shell -p nix-prefetch-git --run "nix-prefetch-git --url https://github.com/oli-obk/cargo_metadata --rev f0df5d0d220c0625cfa1a624ae7cc3d3ac25e31f"
    # Output will contain: "sha256": "0llrrbzqy2yj2ihzb648hxybbl3z6idfa8r781dfnc9rwl475ihh"
    ```
    `submoduleSha256 = "0llrrbzqy2yj2ihzb648hxybbl3z6idfa8r781dfnc9rwl475ihh";`

4.  **Update `flake.nix`:**
    The `submodule-flakes-generated/cargo_metadata/flake.nix` file was updated with these values.

This process ensures that all submodules are properly pinned and managed within the Nix ecosystem, contributing to a fully reproducible build environment.
