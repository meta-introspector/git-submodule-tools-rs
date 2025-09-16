#!/usr/bin/env bash

set -euo pipefail

if [ "$#" -ne 3 ]; then
    echo "Usage: $0 <submodule_name> <submodule_url> <submodule_rev>"
    exit 1
fi

SUBMODULE_NAME="$1"
SUBMODULE_URL="$2"
SUBMODULE_REV="$3"
FLAKE_DIR="./${SUBMODULE_NAME}"
FLAKE_NIX="${FLAKE_DIR}/flake.nix"

echo "Updating ${FLAKE_NIX} with URL: ${SUBMODULE_URL}, Rev: ${SUBMODULE_REV}"

# Update submoduleUrl and submoduleRev
sed -i "s|submoduleUrl = ".*";|submoduleUrl = \"${SUBMODULE_URL}\";|" "${FLAKE_NIX}"
sed -i "s|submoduleRev = ".*";|submoduleRev = \"${SUBMODULE_REV}\";|" "${FLAKE_NIX}"
sed -i "s|submoduleSha256 = ".*";|submoduleSha256 = \"sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=\";|" "${FLAKE_NIX}"


echo "Attempting initial Nix build to discover sha256..."
# Attempt to build, capture stderr for the sha256
NIX_BUILD_OUTPUT=$(nix build "${FLAKE_DIR}" --no-link 2>&1 || true)

if echo "${NIX_BUILD_OUTPUT}" | grep -q "hash mismatch"; then
    echo "Hash mismatch detected. Extracting correct sha256..."
    CORRECT_SHA=$(echo "${NIX_BUILD_OUTPUT}" | grep "got:" | sed -E 's/.*got: +([a-zA-Z0-9=\-]+).*/\1/')
    if [ -z "${CORRECT_SHA}" ]; then
        echo "Failed to extract sha256. Nix build output:"
        echo "${NIX_BUILD_OUTPUT}"
        exit 1
    fi
    echo "Discovered sha256: ${CORRECT_SHA}"

    echo "Updating ${FLAKE_NIX} with correct sha256..."
    sed -i "s|submoduleSha256 = ".*";|submoduleSha256 = \"${CORRECT_SHA}\";|" "${FLAKE_NIX}"

    echo "Performing final Nix build with correct sha256..."
    nix build "${FLAKE_DIR}" --no-link
    echo "Nix build successful for ${SUBMODULE_NAME}."
else
    echo "Initial Nix build succeeded or failed for other reasons. Output:"
    echo "${NIX_BUILD_OUTPUT}"
    if ! echo "${NIX_BUILD_OUTPUT}" | grep -q "building '\/nix\/store"; then
        echo "Error: Nix build failed unexpectedly for ${SUBMODULE_NAME}."
        exit 1
    fi
    echo "Nix build successful for ${SUBMODULE_NAME} (no hash update needed)."
fi

echo "Submodule flake for ${SUBMODULE_NAME} is ready."
