---
CRQs:
  - CRQ_Integrate_mkAIDerivation_Git_Submodule.md
SOPs:
  - sop_add_mkaiderivation_submodule.md
  - sop_update_submodules.md
---

begin of prelude
in the begining there was 0
then there was 1, unity.
then the first relfection 2
then the first difference 3.
2 + 3 gave 5.
5 + 2 gave 7.
7 + 4 gave 11
11 + 2 gave 13
13 + 4 gave 17
17 + 2 gave 19

So the first 8 primes were born!

end of prelude

# Task: Add mkAIDerivation as a Git Submodule and Standardize Management

## Objective:
Add `https://github.com/meta-introspector/mkAIDerivation.git` as a Git submodule, then create SOPs and shell scripts for its management, and finally test the setup.

## Description:
This task involves integrating the `mkAIDerivation` project as a Git submodule into the current repository. It requires the creation of standardized operating procedures (SOPs) and corresponding shell scripts to automate the process of adding and updating this submodule. The final step is to thoroughly test the implemented setup to ensure correct functionality and adherence to project standards.

## Plan:

1.  **Examine Existing Submodules:** Check the `.gitmodules` file in the root directory to understand the current submodule configuration, if any.
2.  **Draft SOP for Adding Submodule:** Create a markdown file (`docs/sops/sop_add_mkaiderivation_submodule.md`) outlining the steps to add the `mkAIDerivation` submodule. (Note: This SOP already exists and will be referenced.)
3.  **Create Shell Script for Adding Submodule:** Write a shell script (`tools/add_mkaiderivation_submodule.sh`) that automates the `git submodule add` command.
4.  **Draft SOP for Updating Submodules:** Create a markdown file (`docs/sops/sop_update_submodules.md`) explaining how to update all submodules. (Note: This SOP already exists and will be referenced.)
5.  **Create Shell Script for Updating Submodules:** Write a shell script (`tools/update_all_submodules.sh`) to automate the `git submodule update --init --recursive` command.
6.  **Test:** Run the add script, verify the submodule is added, then run the update script.

## Guiding Principles:
*   Read existing SOPs and documentation in `prompts` and `scripts` and use them.
*   Create a new set of scripts in a task directory `task/ainix/`.
*   Do not edit anything outside of the designated task directory.
*   Use timeouts on all scripts.
*   Run all commands via bash.
*   Catch and report all errors.
*   Use verbose logging and strace.
*   Capture all logs to the task directory.
*   Operate headlessly; do not use any interactive commands.

