#!/usr/bin/env bash

set -euo pipefail

FLAKES_BASE_DIR="/data/data/com.termux.nix/files/home/pick-up-nix2/source/github/meta-introspector/git-submodule-tools-rs/submodule-flakes"

for FLAKE_DIR in ${FLAKES_BASE_DIR}/*;
do
    if [ -d "${FLAKE_DIR}" ]; then
        SUBMODULE_NAME=$(basename "${FLAKE_DIR}")
        echo "Building flake for submodule: ${SUBMODULE_NAME}"
        (cd "${FLAKE_DIR}" && nix build .)
        echo "Finished building flake for submodule: ${SUBMODULE_NAME}"
    fi
done

echo "All submodule flakes built."
