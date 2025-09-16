#!/usr/bin/env bash

# Script to add the mkAIDerivation submodule to the project.
# This script assumes it's run from the project root.

SUBMODULE_URL="https://github.com/meta-introspector/mkAIDerivation.git"
SUBMODULE_PATH="vendor/meta-introspector/mkAIDerivation"

# Ensure we are in the project root
# This is a placeholder, in a real scenario, you might want more robust checks
# For this exercise, we assume the script is run from the correct directory.

echo "Adding submodule: ${SUBMODULE_URL} to ${SUBMODULE_PATH}"

# Check if the target directory already exists and is not empty
if [ -d "${SUBMODULE_PATH}" ] && [ "$(ls -A ${SUBMODULE_PATH})" ]; then
    echo "Error: Target directory ${SUBMODULE_PATH} exists and is not empty. Please remove it or choose a different path." >&2
    exit 1
fi

git submodule add "${SUBMODULE_URL}" "${SUBMODULE_PATH}"

if [ $? -eq 0 ]; then
    echo "Submodule added successfully. Initializing and updating all submodules..."
    git submodule update --init --recursive
    if [ $? -eq 0 ]; then
        echo "All submodules initialized and updated."
        echo "Please remember to commit the changes:"
        echo "  git add .gitmodules ${SUBMODULE_PATH}"
        echo "  git commit -m \"Add mkAIDerivation as a submodule under ${SUBMODULE_PATH}\""
    else
        echo "Error: Failed to initialize and update submodules." >&2
        exit 1
    fi
else
    echo "Error: Failed to add submodule ${SUBMODULE_URL}." >&2
    exit 1
fi
