# Automated Submodule Update Workflow

## Overview
This document details the automated workflow for keeping Git submodules updated to their latest upstream commits within this project. The process is managed by a GitHub Actions workflow, `submodule_update_check.yml`, which runs on a daily schedule and can also be triggered manually.

## Workflow Details

### Workflow File
`.github/workflows/submodule_update_check.yml`

### Trigger
*   **Scheduled**: Daily at 00:00 UTC via a cron job.
*   **Manual**: Can be triggered manually through the GitHub Actions interface using `workflow_dispatch`.

### Steps

1.  **Checkout Repository**:
    *   The workflow first checks out the main repository.
    *   It uses `actions/checkout@v4` with `submodules: true` to ensure all submodules are also checked out.
    *   Authentication is handled by a Personal Access Token (PAT) stored as a GitHub Secret (`GH_PAT`), which requires `repo` write access to allow the creation of pull requests.

2.  **Update Submodules to Latest Upstream**:
    *   Executes `git submodule update --init --recursive --remote`. This command:
        *   `--init`: Initializes any uninitialized submodules.
        *   `--recursive`: Updates nested submodules.
        *   `--remote`: Fetches the latest commit from the upstream branch of each submodule and updates the submodule to that commit.

3.  **Check for Submodule Changes**:
    *   Configures Git user name and email for the bot.
    *   Stages all changes (`git add .`).
    *   Compares the staged changes with the last commit using `git diff --staged --quiet`.
    *   If changes are detected (meaning submodules have been updated), an output variable `changes_detected` is set to `true`.

4.  **Create Pull Request if Changes Detected**:
    *   This step runs only if `changes_detected` is `true`.
    *   It uses the `peter-evans/create-pull-request@v5` action to automatically create a pull request.
    *   The PR includes the updated submodule references.
    *   The `GH_PAT` is used for authentication to ensure the action has the necessary permissions to create a pull request and potentially trigger subsequent CI runs on the new PR.
    *   **Commit Message**: "chore: Automated submodule update"
    *   **Title**: "Automated Submodule Update"
    *   **Body**: "This PR updates submodules to their latest upstream commits."
    *   **Branch**: `automated-submodule-update` (this is the branch the PR will be created from)
    *   **Base Branch**: `main` (this is the target branch for the PR)

## Configuration and Maintenance

### GitHub Personal Access Token (`GH_PAT`)
*   A GitHub Personal Access Token with `repo` write access is required and must be configured as a repository secret named `GH_PAT`.
*   This token is crucial for the workflow to be able to push changes and create pull requests.

### Adjusting Schedule
*   The update schedule can be modified by changing the `cron` expression in the `on:schedule:` section of the `submodule_update_check.yml` file.

### Base Branch
*   The `base` branch for the pull request (currently `main`) can be adjusted in the "Create Pull Request if Changes Detected" step.

## Troubleshooting

*   **Workflow Failures**: Check the GitHub Actions logs for specific error messages.
*   **PR Not Created**:
    *   Ensure the `GH_PAT` secret is correctly configured and has the necessary `repo` write permissions.
    *   Verify that there were actual submodule updates; if no changes are detected, no PR will be created.
    *   Check for any conflicts that might prevent PR creation (though the `create-pull-request` action is generally robust in handling this).
