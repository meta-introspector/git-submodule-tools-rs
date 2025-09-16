#!/usr/bin/env bash

# This script attempts to build the submodule checkout flake after the sha256 hash has been updated.

FLAKE_DIR="$(dirname "$0")"/llm-nix

echo "Attempting final Nix build for submodule-checkout..."

nix build "$FLAKE_DIR"#submodule-checkout

if [ $? -eq 0 ]; then
  echo "\n--------------------------------------------------------------------------------"
  echo "Nix build successful! The checked-out submodule is available in the Nix store."
  echo "You can find a symlink to it in: ./result"
  echo "--------------------------------------------------------------------------------"
else
  echo "\n--------------------------------------------------------------------------------"
  echo "Nix build failed. Please check the error messages above and ensure the sha256 hash is correct in:"
  echo "  $FLAKE_DIR/flake.nix"
  echo "Also, verify that 'submoduleUrl' and 'submoduleRev' are correctly set."
  echo "--------------------------------------------------------------------------------"
fi
