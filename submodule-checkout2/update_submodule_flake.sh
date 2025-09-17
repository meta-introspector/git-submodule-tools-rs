#!/usr/bin/env bash
# This script automates the process of updating a Nix flake for a Git submodule checkout.
# It handles the discovery and update of the sha256 hash required by Nix's fetchgit.

# Operational Principles Adhered To:
# - Scripting First: Implements the update process via a shell script.
# - Low Memory Environment: Uses bash and grep/awk for file operations.
# - Execution Tracing: Uses 'set -euxo pipefail' for robust error handling and tracing.

set -euxo pipefail

FLAKE_DIR="/data/data/com.termux.nix/files/home/pick-up-nix2/source/github/meta-introspector/git-submodule-tools-rs/submodule-checkout2"
FLAKE_PATH="$FLAKE_DIR/flake.nix"

# --- Usage Information ---
if [[ -z "$1" || -z "$2" ]]; then
  echo "Usage: $0 <submodule_url> <submodule_rev>"
  echo "Example: $0 https://github.com/NixOS/nixpkgs 1234567890abcdef1234567890abcdef12"
  exit 1
fi

SUBMODULE_URL="$1"
SUBMODULE_REV="$2"

echo "--- Starting submodule flake update for URL: $SUBMODULE_URL, Revision: $SUBMODULE_REV ---"

# --- Step 1: Update submoduleUrl and submoduleRev in flake.nix ---
echo "Updating submodule URL and revision in $FLAKE_PATH..."
sed -i "s|submoduleUrl = ".*";|submoduleUrl = "$SUBMODULE_URL";|" "$FLAKE_PATH"
sed -i "s|submoduleRev = ".*";|submoduleRev = "$SUBMODULE_REV";|" "$FLAKE_PATH"
# Reset sha256 to placeholder for discovery
sed -i "s|sha256 = ".*";|sha256 = "sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=";|" "$FLAKE_PATH"

echo "Attempting initial nix-build to discover sha256..."
# --- Step 2: Attempt initial nix-build to discover the correct sha256 ---
# We redirect stderr to stdout and capture the output to parse the sha256 from the error message.
BUILD_OUTPUT=$(nix-build "$FLAKE_PATH" --no-out-link 2>&1 || true) # '|| true' prevents script from exiting on expected failure

# --- Step 3: Extract the correct sha256 from the build output ---
# Look for the line containing "got:    sha256:" and extract the hash.
NEW_SHA256=$(echo "$BUILD_OUTPUT" | grep "got:    sha256:" | awk '{print $NF}')

if [[ -z "$NEW_SHA256" ]]; then
  echo "ERROR: Could not extract sha256 from nix-build output. Please check the URL and revision."
  echo "Nix build output:"
  echo "$BUILD_OUTPUT"
  exit 1
fi

echo "Discovered sha256: $NEW_SHA256"

# --- Step 4: Update flake.nix with the discovered sha256 ---
echo "Updating sha256 in $FLAKE_PATH..."
sed -i "s|sha256 = ".*";|sha256 = "$NEW_SHA256";|" "$FLAKE_PATH"

# --- Step 5: Perform final nix-build to verify ---
echo "Performing final nix-build with the correct sha256..."
nix-build "$FLAKE_PATH" --no-out-link

echo "--- Submodule flake update complete. The submodule is now available in the Nix store. ---"
echo "You can find the checkout at: $(readlink -f ./result)"

# --- Clean up the result symlink ---
if [[ -L ./result ]]; then
  rm ./result
  echo "Cleaned up './result' symlink."
fi
