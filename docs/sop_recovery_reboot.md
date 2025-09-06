# SOP: Post-Reboot Recovery Procedure

## Purpose
This Standard Operating Procedure (SOP) outlines the steps to recover the development environment and codebase after an unexpected system reboot or agent reset, ensuring all work is preserved and a clear recovery path is established.

## Procedure

1.  **Assess Current Git Status:**
    *   Run `git status` to identify any uncommitted changes, untracked files, or discrepancies.
    *   Review the output carefully to understand the state of the working directory.

2.  **Document and Commit Changes:**
    *   If there are uncommitted changes, document the context of these changes. This can be done by reviewing the output of `git diff`.
    *   Stage all relevant changes: `git add .` (or selectively add files as needed).
    *   Commit the changes with a clear, descriptive message indicating that this is a recovery commit.
        ```bash
        git commit -m "RECOVERY: State after unexpected reboot. Review changes for continuity."
        ```
    *   *Rationale:* This step ensures no work is lost and provides a clear checkpoint for post-reboot analysis.

3.  **Create New Recovery Branch:**
    *   Create a new branch specifically for this recovery point. This isolates the recovery work and allows for safe investigation or re-application of changes.
        ```bash
        git branch recovery/$(date +%Y%m%d-%H%M%S)-post-reboot
        ```
    *   *Rationale:* A dedicated recovery branch prevents contamination of main development branches and provides a clear audit trail for the recovery event.

## Verification
*   Confirm the new branch has been created: `git branch`
*   Confirm the commit is on the new branch (and potentially on the previous branch if it was a fast-forward merge): `git log --oneline -n 1`
