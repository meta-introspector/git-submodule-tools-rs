#!/usr/bin/env bash
#
# Test script for ainix submodule management.
#
# This script orchestrates the execution of:
# 1. manage_mkaiderivation_submodule.sh
# 2. update_all_submodules.sh
# And verifies their outcomes.
#
# This script includes:
# - Strict mode for error handling.
# - Timeout for commands.
# - Verbose logging.
# - Strace for detailed system call tracing.
# - Log capture to a dedicated directory.

# --- Configuration ---
LOG_DIR="$(dirname "$(readlink -f "$0")")/logs" # Logs will be stored in a 'logs' subdirectory within the script's directory
TIMESTAMP=$(date +"%Y%m%d_%H%M%S")
LOG_FILE="${LOG_DIR}/test_ainix_submodule_${TIMESTAMP}.log"
STRACE_LOG_FILE="${LOG_DIR}/strace_test_ainix_submodule_${TIMESTAMP}.log"
TIMEOUT_SECONDS=600 # 10 minutes timeout for test script

MANAGE_MKAIDERIVATION_SCRIPT="$(dirname "$(readlink -f "$0")")/manage_mkaiderivation_submodule.sh"
UPDATE_ALL_SUBMODULES_SCRIPT="$(dirname "$(readlink -f "$0")")/update_all_submodules.sh"

# --- Functions ---

# Setup logging
setup_logging() {
    mkdir -p "${LOG_DIR}"
    exec > >(tee -a "${LOG_FILE}") 2>&1
}

# Log messages
log_info() {
    echo "$(date +'%Y-%m-%d %H:%M:%S') INFO: $@"
}

log_error() {
    echo "$(date +'%Y-%m-%d %H:%M:%S') ERROR: $@" >&2
    exit 1
}

# Run command with timeout and strace
run_command() {
    local cmd=("$@")
    log_info "Executing command: ${cmd[*]}"
    log_info "Strace log: ${STRACE_LOG_FILE}"
    
    timeout "${TIMEOUT_SECONDS}" strace -o "${STRACE_LOG_FILE}" -ff -T -e trace=network,file,process "${cmd[@]}"
    local exit_code=$?

    if [ $exit_code -eq 124 ]; then
        log_error "Command timed out after ${TIMEOUT_SECONDS} seconds: ${cmd[*]}"
    elif [ $exit_code -ne 0 ]; then
        log_error "Command failed with exit code ${exit_code}: ${cmd[*]}"
    else
        log_info "Command completed successfully: ${cmd[*]}"
    fi
}

# --- Main Script ---

# Enable strict mode
set -euo pipefail

# Setup logging
setup_logging

log_info "Starting ainix submodule test script."
log_info "Log file: ${LOG_FILE}"

# Navigate to the project root (assuming script is run from a subdirectory)
# This assumes the script is run from source/github/meta-introspector/git-submodule-tools-rs/task/ainix
# and the project root is /data/data/com.termux.nix/files/home/pick-up-nix2
# We need to go up 4 directories to reach the project root.
CURRENT_DIR="$(pwd)"
PROJECT_ROOT="$(dirname "$(dirname "$(dirname "$(dirname "$(readlink -f "$0")")")")")"
log_info "Navigating to project root: ${PROJECT_ROOT}"
cd "${PROJECT_ROOT}" || log_error "Failed to navigate to project root."

# --- Step 1: Manage mkAIDerivation Submodule ---
log_info "Running manage_mkaiderivation_submodule.sh..."
run_command "${MANAGE_MKAIDERIVATION_SCRIPT}"

# Verify mkAIDerivation submodule status
log_info "Verifying mkAIDerivation submodule status after management..."
run_command git submodule status vendor/mkAIDerivation

# --- Step 2: Update All Submodules ---
log_info "Running update_all_submodules.sh..."
run_command "${UPDATE_ALL_SUBMODULES_SCRIPT}"

# Verify all submodules status
log_info "Verifying all submodules status after update..."
run_command git submodule status

log_info "Ainix submodule test script finished successfully."

# Return to original directory
log_info "Returning to original directory: ${CURRENT_DIR}"
cd "${CURRENT_DIR}" || log_error "Failed to return to original directory."
