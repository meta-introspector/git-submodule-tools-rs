#!/usr/bin/env bash

# update_all_submodules.sh
# This script updates all Git submodules in the current repository.

# Exit immediately if a command exits with a non-zero status.
set -e

echo "Updating all Git submodules..."

# Update all submodules, initializing any that haven't been initialized yet,
# and doing so recursively for nested submodules.
git submodule update --init --recursive

echo "All Git submodules updated successfully."
