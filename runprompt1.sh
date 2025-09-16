#!/usr/bin/env bash

# Define the project root directory
PROJECT_ROOT="/data/data/com.termux.nix/files/home/pick-up-nix2"

# Define the list of submodules to build
SUBMODULES=(
    "vendor/cargo_metadata"
    "vendor/gitoxide"
    "vendor/meta-introspector/meta-meme"
    "vendor/meta-introspector/meta-meme.wiki"
    "vendor/octocrab"
    "vendor/zola"
)

echo "Starting submodule builds..."

# Change to the project root directory
cd "$PROJECT_ROOT" || { echo "Failed to change to project root: $PROJECT_ROOT"; exit 1; }

# Iterate through each submodule and attempt to build it
for SUBMODULE_PATH in "${SUBMODULES[@]}"; do
    # Extract the submodule name from its path
    SUBMODULE_NAME=$(basename "$SUBMODULE_PATH")
    LOG_FILE="${PROJECT_ROOT}/build_output_${SUBMODULE_NAME}.log"

    echo "Attempting to build submodule: ${SUBMODULE_NAME} (path: ${SUBMODULE_PATH})"
    echo "Logging output to: ${LOG_FILE}"

    # Execute the nix build command
    # Assuming the flake.nix in PROJECT_ROOT can build these submodules as packages
    # The exact flake output path might need adjustment based on the actual flake structure
    nix build ".#${SUBMODULE_NAME}" &> "$LOG_FILE"

    if [ $? -eq 0 ]; then
        echo "Successfully built ${SUBMODULE_NAME}"
    else
        echo "Failed to build ${SUBMODULE_NAME}. Check ${LOG_FILE} for details."
    fi
done

echo "All submodule build attempts completed."
