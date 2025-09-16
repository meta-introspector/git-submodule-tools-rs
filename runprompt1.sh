#!/usr/bin/env bash

# Define the list of submodule names based on the provided paths
SUBMODULE_NAMES=(
    "cargo_metadata"
    "gitoxide"
    "meta-meme"
    "meta-meme.wiki"
    "octocrab"
    "zola"
)

# Define the absolute path to the main flake root
FLAKE_ROOT="/data/data/com.termux.nix/files/home/pick-up-nix2"

# Loop through each submodule and attempt a Nix build
for submodule_name in "${SUBMODULE_NAMES[@]}"; do
    echo "Attempting Nix build for submodule: $submodule_name"
    # Change to the main project root to ensure flake.nix is found
    # and then execute the nix build command.
    # Output is redirected to a log file in the main project root.
    (cd "$FLAKE_ROOT" && nix build ".#${submodule_name}" 2>&1 | tee "${FLAKE_ROOT}/build_output_${submodule_name}.log")
    if [ $? -eq 0 ]; then
        echo "Successfully built $submodule_name"
    else
        echo "Failed to build $submodule_name"
    fi
done

echo "All submodule builds attempted."