#!/bin/bash

source "$(dirname "$0")"/../../scripts/lib_git_submodule.sh

# boot.sh
# This script demonstrates how a Gemini agent can claim a task.

AGENT_ID="Gemini-Alpha"
TASKS_DIR="/data/data/com.termux/files/home/storage/github/git-submodule-tools/tasks"

echo "${AGENT_ID} is booting up..."

# Find an unclaimed task (now looking for .toml files)
UNCLAIMED_TASK_FILE=$(grep -lR "assigned_agent = \"(Unassigned)\"" "${TASKS_DIR}" | head -n 1)

if [ -z "$UNCLAIMED_TASK_FILE" ]; then
    echo "No unclaimed tasks found. ${AGENT_ID} is standing by."
else
    TASK_ID=$(basename "$UNCLAIMED_TASK_FILE" .toml)
    echo "${AGENT_ID} found unclaimed task: ${TASK_ID}"

    # Claim the task by updating the file
    echo "Claiming task ${TASK_ID}..."
    # Use sed to replace the assigned_agent and status fields in the TOML file
    sed -i "s/assigned_agent = \"(Unassigned)\"/assigned_agent = \"${AGENT_ID}\"/g" "$UNCLAIMED_TASK_FILE"
    sed -i "s/status = \"To Do\"/status = \"In Progress\"/g" "$UNCLAIMED_TASK_FILE"

    echo "Task ${TASK_ID} claimed by ${AGENT_ID}."
    echo "Please review the changes and commit them:"
    echo "  git add ${UNCLAIMED_TASK_FILE}"
    git_commit_message "Claimed task ${TASK_ID} - Started work"

    # Display git status to show the change
    git_status_submodule
fi
