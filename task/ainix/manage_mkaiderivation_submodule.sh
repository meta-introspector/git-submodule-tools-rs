#!/usr/bin/env bash

source "$(dirname "$0")"/../../../scripts/lib_git_submodule.sh

#
# Script to manage the mkAIDerivation Git submodule (initialize and update).
#
# This script includes:
# - Strict mode for error handling.
# - Timeout for git commands.
# - Verbose logging.
# - Strace for detailed system call tracing.
# - Log capture to a dedicated directory.

# --- Configuration ---
SUBMODULE_PATH="vendor/mkAIDerivation"
LOG_DIR="$(dirname "$(readlink -f "$0")")/logs" # Logs will be stored in a 'logs' subdirectory within the script's directory
TIMESTAMP=$(date +"%Y%m%d_%H%M%S")
LOG_FILE="${LOG_DIR}/manage_mkaiderivation_submodule_${TIMESTAMP}.log"
STRACE_LOG_FILE="${LOG_DIR}/strace_manage_mkaiderivation_submodule_${TIMESTAMP}.log"
TIMEOUT_SECONDS=300 # 5 minutes timeout for git commands

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

log_info "Starting mkAIDerivation submodule management script."
log_info "Submodule path: ${SUBMODULE_PATH}"
log_info "Log file: ${LOG_FILE}"

# Navigate to the project root (assuming script is run from a subdirectory)
# This assumes the script is run from source/github/meta-introspector/git-submodule-tools-rs/task/ainix
# and the project root is /data/data/com.termux.nix/files/home/pick-up-nix2
# We need to go up 4 directories to reach the project root.
CURRENT_DIR="$(pwd)"
PROJECT_ROOT="$(dirname "$(dirname "$(dirname "$(dirname "$(readlink -f "$0")")")")")"
log_info "Navigating to project root: ${PROJECT_ROOT}"
cd "${PROJECT_ROOT}" || log_error "Failed to navigate to project root."

# Initialize and update the specific submodule
log_info "Initializing and updating mkAIDerivation submodule..."
run_command git_submodule_update_init_recursive "${SUBMODULE_PATH}"

# Verify submodule status
log_info "Verifying mkAIDerivation submodule status..."
run_command git_submodule_status "${SUBMODULE_PATH}"

log_info "mkAIDerivation submodule management script finished."

# Return to original directory
log_info "Returning to original directory: ${CURRENT_DIR}"
cd "${CURRENT_DIR}" || log_error "Failed to return to original directory."
