# Automated Submodule Updates

This document outlines the process for automating Git submodule updates using GitHub Actions.

## Overview

To ensure that project dependencies (managed as Git submodules) remain current and to proactively identify potential integration issues, an automated GitHub Actions workflow has been implemented. This workflow periodically checks for new commits in upstream submodule repositories and, if updates are found, automatically creates a pull request to incorporate these changes into the main repository.

## Workflow Details

**Workflow File:** `.github/workflows/submodule_update_check.yml`

**Trigger:**

*   **Scheduled:** The workflow runs daily at 00:00 UTC.
*   **Manual:** The workflow can also be triggered manually via the "Run workflow" button in the GitHub Actions tab.

**Steps:**

1.  **Checkout Repository:** The main repository is checked out, including its submodules. A Personal Access Token (PAT) with `repo` scope is required for this step to ensure proper authentication for private repositories and to allow the workflow to create pull requests.

    *   **Secret:** `GH_PAT` (stored in GitHub Secrets) is used for authentication.

2.  **Update Submodules to Latest Upstream:** The `git submodule update --init --recursive --remote` command is executed. This command fetches the latest commits from the upstream repositories of all submodules and updates the local submodule references to point to these latest commits.

3.  **Check for Submodule Changes:** After updating, the workflow checks if any changes were made to the submodule references. If `git add .` followed by `git diff --staged --quiet` indicates changes, it means submodules have been updated.

4.  **Create Pull Request if Changes Detected:** If submodule updates are detected, a new pull request is automatically created to the `main` branch (or your configured base branch). This PR will contain the updated submodule references.

    *   **Action Used:** `peter-evans/create-pull-request@v5`
    *   **Commit Message:** `chore: Automated submodule update`
    *   **PR Title:** `Automated Submodule Update`
    *   **PR Body:** `This PR updates submodules to their latest upstream commits.`
    *   **Branch:** The PR is created from a new branch named `automated-submodule-update`.

## Configuration

### GitHub Secret (`GH_PAT`)

To enable this workflow, you must create a GitHub Personal Access Token (PAT) with the `repo` scope and add it as a repository secret named `GH_PAT` in your GitHub repository settings.

**Steps to create a PAT:**

1.  Go to your GitHub settings (profile picture -> Settings).
2.  Navigate to "Developer settings" -> "Personal access tokens" -> "Tokens (classic)".
3.  Click "Generate new token" (classic).
4.  Give it a descriptive name (e.g., `automated-submodule-updater`).
5.  Set an expiration date (or choose no expiration, but be mindful of security).
6.  Select the `repo` scope (full control of private repositories).
7.  Click "Generate token" and copy the token.

**Steps to add the PAT as a repository secret:**

1.  In your GitHub repository, go to "Settings" -> "Secrets and variables" -> "Actions" -> "Repository secrets".
2.  Click "New repository secret".
3.  Name the secret `GH_PAT`.
4.  Paste the copied PAT into the "Secret value" field.
5.  Click "Add secret".

## Troubleshooting

*   **Workflow not triggering:** Double-check the `cron` schedule in the workflow file and ensure the `GH_PAT` secret is correctly configured.
*   **Pull Request not created:** Verify that the `GH_PAT` has the necessary `repo` permissions. Check the workflow run logs for any errors during the "Create Pull Request" step.
*   **Submodules not updating:** Ensure that the submodule URLs in `.gitmodules` are correct and accessible by the GitHub Actions runner. Also, confirm that the upstream repositories have new commits.
