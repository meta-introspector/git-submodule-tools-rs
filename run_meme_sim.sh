#!/bin/bash

# run_meme_sim.sh
# Automates the setup and execution of the SETI@Home Meme Life Simulation.

echo "--- SETI@Home Meme Life Simulation Setup ---"

# --- 1. Check for gemini-cli ---
GEMINI_CLI_PATH=""

# Check common installation paths
if command -v gemini &> /dev/null; then
    GEMINI_CLI_PATH=$(command -v gemini)
    echo "Found gemini-cli in PATH: ${GEMINI_CLI_PATH}"
elif [ -f "${HOME}/storage/github/gemini-cli/target/release/gemini" ]; then
    GEMINI_CLI_PATH="${HOME}/storage/github/gemini-cli/target/release/gemini"
    echo "Found gemini-cli at ~/storage/github/gemini-cli: ${GEMINI_CLI_PATH}"
elif [ -f "./vendor/gemini-cli/target/release/gemini" ]; then
    GEMINI_CLI_PATH="./vendor/gemini-cli/target/release/gemini"
    echo "Found gemini-cli as a submodule: ${GEMINI_CLI_PATH}"
else
    echo "gemini-cli not found. Please install it first."
    echo "Option 1 (Recommended): cargo install gemini-cli"
    echo "Option 2: git clone https://github.com/your-gemini-cli-repo/gemini-cli.git && cd gemini-cli && cargo build --release"
    exit 1
fi

# --- 2. Build the eco_pendulum_indexer crate ---
echo "Building the eco_pendulum_indexer (Abulafia) simulation client..."
cargo build --release --package eco_pendulum_indexer

if [ $? -ne 0 ]; then
    echo "Error: Failed to build eco_pendulum_indexer. Please check your Rust setup."
    exit 1
fi

# --- 3. Prepare the 'fragments' directory ---
FRAGMENTS_DIR="./fragments"
if [ ! -d "${FRAGMENTS_DIR}" ]; then
    echo "Creating 'fragments' directory for meme input..."
    mkdir -p "${FRAGMENTS_DIR}"
    echo "Please add some text files (e.g., .txt, .md) to the '${FRAGMENTS_DIR}' directory."
    echo "Example: echo \"The meme evolves.\" > ${FRAGMENTS_DIR}/initial_meme.txt"
    echo "Abulafia needs text to weave its tales."
    # Exit here to allow user to add fragments
    exit 0
fi

# --- 4. Run the simulation ---
echo "Launching the SETI@Home Meme Life Simulation..."
# Use the found gemini-cli path to run the simulation
# The simulation client (eco_pendulum_indexer) will use gemini-cli internally
# to interact with the LLM.
./target/release/eco_pendulum_indexer

echo "--- Simulation Finished ---"
echo "Remember to contribute your results via Pull Requests!"
