# Plan for Tmux-Driven Task Management and Monitoring

## Context

This document outlines a strategy for leveraging `tmux` to manage and monitor the execution of tasks within the `git-submodule-tools` project. It integrates with the existing task management system (TOML-based tasks in `tasks/`) and the Gemini agent workflow. The goal is to provide a robust, observable, and reproducible environment for task execution.

## Objectives

*   **Structured Task Execution:** Launch individual tasks in dedicated `tmux` panes or windows for isolation and clarity.
*   **Real-time Monitoring:** Observe the output and progress of tasks as they execute.
*   **Reproducibility:** Ensure that task execution environments can be easily recreated.
*   **Integration with Task System:** Facilitate the claiming, execution, and status updates of tasks within the `tmux` environment.

## Workflow for Task Execution in Tmux

### 1. Initial Setup (Agent Boot)

The `boot-tmux.sh` script initiates a `tmux` session and launches a Gemini agent (like myself) within it, providing this `tmux-plan.md` as initial context.

### 2. Task Identification and Claiming

*   **Identify Unclaimed Task:** The Gemini agent (or a human operator) will use the `boot.sh` script (or a more advanced `agent_task_runner` once developed) to identify and claim an unclaimed task from the `tasks/` directory.
*   **Claim Task:** The `boot.sh` script will update the `assigned_agent` and `status` fields in the chosen task's TOML file to `In Progress`. This change must be committed to Git.

### 3. Launching a Task in a Dedicated Tmux Pane/Window

Once a task is claimed, it should be launched in a dedicated `tmux` pane or window for isolated execution and monitoring.

*   **Create New Window/Pane:**
    *   To create a new `tmux` window for the task: `tmux new-window -n "task-<TASK_ID>"`
    *   To split the current window into a new pane for the task: `tmux split-window -v` (vertical split) or `tmux split-window -h` (horizontal split)

*   **Navigate to Project Root:** In the new pane/window, navigate to the project root:
    ```bash
    cd /data/data/com.termux/files/home/storage/github/git-submodule-tools
    ```

*   **Execute Task Command:** Run the command(s) necessary to execute the task. This might involve:
    *   Running a Rust binary: `./target/release/git_submodule_health_checker`
    *   Executing a script: `./docs/qa/git_repo_management/run_qa_tests.sh`
    *   Invoking `cargo run` for a specific crate: `cargo run --manifest-path crates/zos_initializer/Cargo.toml`

    Example:
    ```bash
    cargo run --manifest-path crates/zos_initializer/Cargo.toml -- --task-id G-MN-001
    ```
    (Note: The `-- --task-id` part is hypothetical and depends on the `zos_initializer` implementation.)

### 4. Monitoring Task Progress

*   **Real-time Output:** Observe the command output directly in the `tmux` pane.
*   **Pane Management:**
    *   Switch between panes: `Ctrl-b <arrow-key>`
    *   Switch between windows: `Ctrl-b <window-number>`
    *   Synchronize panes (send input to all panes in a window): `Ctrl-b :set synchronize-panes` (toggle)
*   **Scrollback Buffer:** Use `Ctrl-b [` to enter copy mode and scroll through the output.

### 5. Task Completion and Status Update

*   **Verify Acceptance Criteria:** Once the task execution completes, review the output and verify that the acceptance criteria (defined in the task's TOML file) have been met.
*   **Update Task Status:** Modify the task's TOML file (`tasks/<TASK_ID>.toml`) to update its `status` field to `"Done"` or `"Failed"` as appropriate.
*   **Commit Changes:** Commit the updated task file and any code changes resulting from the task.

### 6. Session Management

*   **Detach from Session:** `Ctrl-b d` (leaves the session running in the background)
*   **Attach to Session:** `tmux attach-session -t gemini-task-manager`
*   **List Sessions:** `tmux ls`
*   **Kill Session:** `tmux kill-session -t gemini-task-manager` (only when all tasks are complete and session is no longer needed)

## Conceptual Integration

This `tmux`-driven workflow embodies the project's meta-narrative:

*   **Chronos-Code Paradox:** `tmux` provides a stable temporal environment for observing code evolution and task execution, helping to manage the paradox of change.
*   **Heroification:** Successful task completion within `tmux` contributes to the "heroification" of the agent and the project's progress.
*   **Memification/Quasi-Meta-Memification:** The structured, observable nature of `tmux` sessions can itself become part of the project's internal "memes" for efficient and transparent development.

This plan provides a framework for agents to effectively manage their work within the `git-submodule-tools` ecosystem.

## Asciinema Recordings: Visualizing Task Workflows

To further enhance transparency, reproducibility, and knowledge sharing, `asciinema` recordings can be integrated into the task management workflow. These recordings capture terminal sessions, providing a visual and interactive log of task execution.

### How to Record a Session

To record a `tmux` session (or any terminal session), use the `asciinema rec` command. You can specify an output file for the recording.

```bash
asciinema rec /data/data/com.termux/files/home/storage/github/git-submodule-tools/docs/recordings/task_claiming_workflow.cast
```

*   Press `Ctrl+D` or type `exit` to stop the recording.

### How to Play a Recording

To play a `.cast` file locally, use the `asciinema play` command:

```bash
asciinema play /data/data/com.termux/files/home/storage/github/git-submodule-tools/docs/recordings/task_claiming_workflow.cast
```

### Suggested Recording Content

Consider creating `asciinema` recordings for the following key workflows:

*   **Task Claiming Workflow:** A recording demonstrating the `boot.sh` script in action, showing an agent claiming a task and the resulting `git status`.
*   **Task Execution Example:** A recording of a specific task being executed (e.g., running `cargo run` for `task_converter` or `zos_initializer`), showing the output and any interactions.
*   **Troubleshooting Session:** Recordings of debugging or troubleshooting steps for complex issues.
*   **New Feature Demonstration:** A quick demo of a newly implemented feature.

### Storage Location

All `.cast` files should be stored in the `docs/recordings/` directory within the project repository. This ensures they are version-controlled and easily accessible.

```bash
mkdir -p /data/data/com.termux/files/home/storage/github/git-submodule-tools/docs/recordings
```

By integrating `asciinema` recordings, we create a richer, more accessible history of our development process, aligning with our goals of transparency and reproducibility.
