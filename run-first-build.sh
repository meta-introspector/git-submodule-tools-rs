#!/usr/bin/env bash

# This script attempts to build the submodule checkout flake for the first time.
# It is expected to fail and output the correct sha256 hash needed for the flake.nix.

FLAKE_DIR="$(dirname "$0")"/llm-nix

echo "Attempting initial Nix build for submodule-checkout..."
echo "This is expected to fail and provide the correct sha256 hash."

nix build "$FLAKE_DIR"#submodule-checkout

if [ $? -ne 0 ]; then
  echo "\n--------------------------------------------------------------------------------"
  echo "Initial build failed as expected. Please find the 'got:' sha256 hash in the output above."
  echo "You need to copy this hash and update the 'submoduleSha256' variable in the following file:"
  echo "  $FLAKE_DIR/flake.nix"
  echo "After updating, run the 'run-final-build.sh' script."
  echo "--------------------------------------------------------------------------------"
else
  echo "Unexpected: Initial build succeeded. The sha256 might already be correct or the submodule is empty."
  echo "Please verify the contents of $FLAKE_DIR/flake.nix and the output."
fi
