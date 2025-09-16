#!/usr/bin/env bash

# This script iterates through specified submodules and attempts to build them using Nix.

# Define the list of relevant submodules
SUBMODULES=(
    "cargo_metadata"
    "gitoxide"
    "meta-introspector/meta-meme"
    "meta-introspector/meta-meme.wiki"
    "octocrab"
    "zola"
)

# Main project root where the flake.nix is located
MAIN_PROJECT_ROOT="/data/data/com.termux.nix/files/home/pick-up-nix2"

# Directory to store build logs
LOG_DIR="${MAIN_PROJECT_ROOT}/logs"
mkdir -p "${LOG_DIR}"

echo "Starting reproducible submodule build process..."

for SUBMODULE in "${SUBMODULES[@]}"; do
    SUBMODULE_NAME=$(basename "${SUBMODULE}")
    LOG_FILE="${LOG_DIR}/build_output_${SUBMODULE_NAME}.log"

    echo "Attempting to build submodule: ${SUBMODULE} (log: ${LOG_FILE})"

    # Execute nix build from the main project root, targeting the submodule
    # Assuming the flake.nix in MAIN_PROJECT_ROOT exposes these submodules as packages
    # The exact flake path might need adjustment based on how the flake is structured
    if nix build "${MAIN_PROJECT_ROOT}#${SUBMODULE_NAME}" &> "${LOG_FILE}"; then
        echo "Successfully built ${SUBMODULE_NAME}"
    else
        echo "Failed to build ${SUBMODULE_NAME}. Check ${LOG_FILE} for details."
    fi
done

echo "Submodule build process completed."