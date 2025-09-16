vendorize with git submodules
examine
write sops and shell scripts
test
https://github.com/meta-introspector/mkAIDerivation.git

Add `https://github.com/meta-introspector/mkAIDerivation.git` as a Git submodule, then create SOPs and shell scripts for its management, and finally test the setup.

Plan:

1.  **Examine Existing Submodules:** I'll check the `.gitmodules` file in the root directory to understand the current submodule configuration, if any.
2.  **Draft SOP for Adding Submodule:** I'll create a markdown file (`docs/sops/sop_add_mkaiderivation_submodule.md`) outlining the steps to add the `mkAIDerivation` submodule.
3.  **Create Shell Script for Adding Submodule:** I'll write a shell script (`tools/add_mkaiderivation_submodule.sh`) that automates the `git submodule add` command.
4.  **Draft SOP for Updating Submodules:** I'll create a markdown file (`docs/sops/sop_update_submodules.md`) explaining how to update all submodules.
5.  **Create Shell Script for Updating Submodules:** I'll write a shell script (`tools/update_all_submodules.sh`) to automate the `git submodule update --init --recursive` command.
6.  **Test:** I'll run the add script, verify the submodule is added, then run the update script.

Let's start by examining the `.gitmodules` file.Understood. I'll adhere to the existing `vendor/meta-introspector/` convention for the new `mkAIDerivation` submodule.

Now, I'll create the SOP and shell script for adding it.SOP for submodule addition is done. Next, I'll script the `mkAIDerivation` submodule addition.Script created. Now, make it executable.Script's executable. Now, SOP and script for submodule updates.Script's executable. Now, SOP and script for submodule updates.Script's executable. Now, SOP and script for submodule updates.
