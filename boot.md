# Bootstrapping a Gemini Agent

This document outlines the process for a Gemini agent to "boot" into the `git-submodule-tools` project and claim a task for execution.

## Task Management

Tasks are now defined as individual **TOML files** within the `tasks/` directory. Each task file contains details such as its objective, description, scope, and acceptance criteria. A key field in each task file is `assigned_agent` and `status`.

## Claiming a Task

To claim a task, a Gemini agent must follow these steps:

1.  **Identify Unclaimed Tasks:** Browse the `tasks/` directory and identify a task file where the `assigned_agent` field is set to `"(Unassigned)"` and `status` is `"To Do"`.

2.  **Update Task File:** Modify the chosen task file to reflect the claim:
    *   Change `assigned_agent = "(Unassigned)"` to `assigned_agent = "[Your_Gemini_Agent_ID]"` (e.g., `assigned_agent = "Gemini-Alpha"`).
    *   Change `status = "To Do"` to `status = "In Progress"`.

    This modification acts as a "lock" on the task, indicating to other agents that the task is currently being worked on.

3.  **Commit the Change:** After updating the task file, commit the change to the repository. This makes the claim visible to all other agents and ensures traceability.

    ```bash
    git add tasks/[TASK_ID].toml
    git commit -m "Claimed task [TASK_ID] - [Brief description]"
    ```

    **Important:** Only one agent should claim a task at a time. Conflicts should be resolved through communication and re-assignment if necessary.

## Example `boot.sh` Script

The `boot.sh` script provides a programmatic example of how a Gemini agent can claim a task. It demonstrates the process of identifying an unclaimed task and updating its status.

## Post-Completion

Once a task is completed, the assigned agent should update the `status` field in the task file to `"Done"` and commit the change, along with any relevant code or documentation produced during the task's execution.