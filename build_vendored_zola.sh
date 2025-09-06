#!/bin/bash

# build_vendored_zola.sh
# Builds the vendored Zola executable from source.

echo "Building vendored Zola..."

# Navigate to the Zola submodule directory
cd vendor/zola || { echo "Error: vendor/zola directory not found."; exit 1; }

# Build Zola in release mode
cargo build --release

# Check if the build was successful
if [ $? -ne 0 ]; then
    echo "Error: Zola build failed."
    exit 1
fi

echo "Zola built successfully. Executable is at vendor/zola/target/release/zola"

# Navigate back to the project root
cd ../..
