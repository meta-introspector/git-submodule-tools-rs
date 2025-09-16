#!/usr/bin/env bash

set -euo pipefail

SUBMODULE_FLAKES_DIR="/data/data/com.termux.nix/files/home/pick-up-nix2/source/github/meta-introspector/git-submodule-tools-rs/submodule-flakes-generated"
GITMODULES_FILE="/data/data/com.termux.nix/files/home/pick-up-nix2/source/github/meta-introspector/git-submodule-tools-rs/.gitmodules"
UPDATE_SCRIPT="${SUBMODULE_FLAKES_DIR}/update_submodule_flake.sh"
REPO_ROOT="/data/data/com.termux.nix/files/home/pick-up-nix2/source/github/meta-introspector/git-submodule-tools-rs"
PYTHON_SCRIPT="/data/data/com.termux.nix/files/home/pick-up-nix2/source/github/meta-introspector/git-submodule-tools-rs/parse_gitmodules.py"

if [ ! -f "${GITMODULES_FILE}" ]; then
    echo "Error: .gitmodules file not found at ${GITMODULES_FILE}"
    exit 1
fi

if [ ! -f "${UPDATE_SCRIPT}" ]; then
    echo "Error: update_submodule_flake.sh script not found at ${UPDATE_SCRIPT}"
    exit 1
fi

if [ ! -f "${PYTHON_SCRIPT}" ]; then
    echo "Error: Python parsing script not found at ${PYTHON_SCRIPT}"
    exit 1
fi

echo "Initializing and updating Git submodules..."
pushd "${REPO_ROOT}" > /dev/null
git submodule update --init --recursive
popd > /dev/null
echo "Git submodules initialized and updated."

echo "Generating Nix flakes for all Git submodules..."

# Read .gitmodules and process each submodule using Python script
SUBMODULE_INFO=$(python3 "${PYTHON_SCRIPT}" "${GITMODULES_FILE}")

echo "${SUBMODULE_INFO}" | while IFS=',' read -r submodule_name submodule_path submodule_url; do
    echo "Processing submodule: ${submodule_name}"
    echo "  Path: ${submodule_path}"
    echo "  URL: ${submodule_url}"

    # Get the current revision of the submodule
    pushd "${REPO_ROOT}" > /dev/null
    echo "DEBUG: Running 'git submodule status ${submodule_path}'"
    GIT_SUBMODULE_STATUS_OUTPUT=$(git submodule status "${submodule_path}")
    echo "DEBUG: Output of git submodule status: ${GIT_SUBMODULE_STATUS_OUTPUT}"
    SUBMODULE_REV=$(echo "${GIT_SUBMODULE_STATUS_OUTPUT}" | head -n 1 | cut -d ' ' -f 1 | sed 's/^-//')
    echo "DEBUG: Extracted SUBMODULE_REV: ${SUBMODULE_REV}"
    popd > /dev/null

    if [ -z "${SUBMODULE_REV}" ]; then
        echo "Warning: Could not determine revision for submodule ${submodule_name}. Skipping."
        continue
    fi
    echo "  Revision: ${SUBMODULE_REV}"

    # Create directory for the submodule flake if it doesn't exist
    mkdir -p "${SUBMODULE_FLAKES_DIR}/${submodule_name}"

    # Generate initial flake.nix if it doesn't exist
    FLAKE_NIX_PATH="${SUBMODULE_FLAKES_DIR}/${submodule_name}/flake.nix"
    if [ ! -f "${FLAKE_NIX_PATH}" ]; then
        echo "Creating initial flake.nix for ${submodule_name}..."
        SUBMODULE_FULL_PATH="${REPO_ROOT}/${submodule_path}"
        if [ -f "${SUBMODULE_FULL_PATH}/Cargo.toml" ]; then
            echo "Detected Rust project: ${submodule_name}. Generating Naersk flake."
            cat <<EOF > "${FLAKE_NIX_PATH}"
{
  description = "Nix flake for ${submodule_name}";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    naersk.url = "github:nix-community/naersk";
  };

  outputs = { self, nixpkgs, flake-utils, naersk } :
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = (import nixpkgs) {
          inherit system;
        };

        naersk' = pkgs.callPackage naersk {};

      in rec {
        defaultPackage = naersk'.buildPackage {
          src = pkgs.fetchgit {
            url = "${submodule_url}";
            rev = "${SUBMODULE_REV}";
            sha256 = "sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA="; # Placeholder, will be updated by update_submodule_flake.sh
          };
        };
      }
    );
}
EOF
        else
            echo "Detected non-Rust project: ${submodule_name}. Generating generic flake."
            cat <<EOF > "${FLAKE_NIX_PATH}"
{
  description = "Nix flake for ${submodule_name}";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs = { self, nixpkgs } :
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs {
        inherit system;
      };
      submoduleUrl = "${submodule_url}";
      submoduleRev = "${SUBMODULE_REV}";
      submoduleSha256 = "sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA="; # Placeholder, will be updated by update_submodule_flake.sh
    in {
      packages.${system}.default = pkgs.stdenv.mkDerivation {
        pname = "${submodule_name}";
        version = "0.1.0";

        src = pkgs.fetchgit {
          url = submoduleUrl;
          rev = submoduleRev;
          sha256 = submoduleSha256;
        };

        buildPhase = "echo 'Submodule ${submodule_name} fetched successfully.'";

        installPhase = "mkdir -p \$out/share/${submodule_name} && cp -r \$src/* \$out/share/${submodule_name}";
      };
    };
}
EOF
        fi
    fi

    # Call the update script
    "${UPDATE_SCRIPT}" "${submodule_name}" "${submodule_url}" "${SUBMODULE_REV}"
    echo "----------------------------------------------------"
done

echo "All submodule flakes generated and updated."