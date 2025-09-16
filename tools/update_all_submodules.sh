#!/usr/bin/env bash

# SOP: Updating Git Submodules
# This script automates the process of updating all Git submodules within this project.

# Navigate to the project root (assuming the script is run from the project root or a subdirectory)
# If run from a subdirectory, you might need to adjust this.
PROJECT_ROOT=$(git rev-parse --show-toplevel)
cd "$PROJECT_ROOT" || exit 1

echo "Updating all Git submodules..."

# Execute the git submodule update command
git submodule update --init --recursive

if [ $? -eq 0 ]; then
  echo "All Git submodules updated successfully."
else
  echo "Error: Failed to update Git submodules."
  exit 1
fi