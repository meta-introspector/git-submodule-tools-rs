#!/usr/bin/env bash

set -euo pipefail

# Base directory for generated flakes
FLAKES_BASE_DIR="/data/data/com.termux.nix/files/home/pick-up-nix2/source/github/meta-introspector/git-submodule-tools-rs/submodule-flakes"

# Read .gitmodules to get submodule paths and URLs
# Using git config --file to parse .gitmodules

# Get all submodule names
submodule_names=$(git config --file .gitmodules --get-regexp submodule.*.path | awk '{print $2}')

for submodule_path in ${submodule_names[@]};
do
    echo "Processing submodule: ${submodule_path}"

    # Get submodule URL
    submodule_url=$(git config --file .gitmodules submodule.${submodule_path}.url)

    # Get current revision (commit hash) of the submodule
    # We need to be in the main repo to get the correct submodule status
    # This assumes the script is run from the project root
    submodule_rev=$(git submodule status ${submodule_path} | awk '{print $1}' | sed 's/^-//')

    # Sanitize submodule path for flake directory name
    submodule_name_sanitized=$(echo ${submodule_path} | sed 's/\\/_g' | sed 's/-/_/g')
    FLAKE_DIR="${FLAKES_BASE_DIR}/${submodule_name_sanitized}"
    FLAKE_NIX_PATH="${FLAKE_DIR}/flake.nix"

    if [ ! -f "${FLAKE_NIX_PATH}" ]; then
        echo "Error: flake.nix not found for ${submodule_path} at ${FLAKE_NIX_PATH}"
        continue
    fi

    echo "Fetching SHA256 for ${submodule_url} at revision ${submodule_rev}"
    # Use nix-prefetch-url to get the sha256 hash
    # --unpack is important for git repositories
    submodule_sha256=$(nix-prefetch-url --unpack "${submodule_url}" "${submodule_rev}" 2>&1 | tail -n 1)

    if [[ ! "${submodule_sha256}" =~ ^sha256- ]]; then
        echo "Error: Could not obtain valid sha256 for ${submodule_path}. Output: ${submodule_sha256}"
        continue
    fi

    echo "Updating ${FLAKE_NIX_PATH} with rev: ${submodule_rev} and sha256: ${submodule_sha256}"

    # Update flake.nix with the new rev and sha256
    # Using sed for in-place replacement
    sed -i "s|rev = \"CHANGEME\";|rev = \"${submodule_rev}\";|" "${FLAKE_NIX_PATH}"
    sed -i "s|sha256 = \"CHANGEME\";|sha256 = \"${submodule_sha256}\";|" "${FLAKE_NIX_PATH}"
    sed -i "s|url = \"CHANGEME\";|url = \"${submodule_url}\";|" "${FLAKE_NIX_PATH}"

    echo "Successfully updated ${FLAKE_NIX_PATH}"
done

echo "All submodule flakes updated."
