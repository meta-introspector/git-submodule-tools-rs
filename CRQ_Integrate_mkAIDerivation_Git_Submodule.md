## CRQ: Integrate mkAIDerivation Git Submodule

**Objective:** To integrate the `mkAIDerivation` repository as a Git submodule and establish standardized procedures for its management.

**Description:** This CRQ covers the process of adding `https://github.com/meta-introspector/mkAIDerivation.git` as a Git submodule, developing SOPs and shell scripts for its addition and updates, and verifying the setup.

**Scope:** Git submodule configuration (`.gitmodules`), shell scripts for submodule management, and documentation (SOPs).

**Acceptance Criteria:** The `mkAIDerivation` submodule is successfully added and initialized. Dedicated SOPs and shell scripts for adding and updating the submodule are created and functional. The setup is tested and verified.

**Assigned Agent:** Gemini (Self-assigned)
**Status:** Completed

**Notes:**
- The `mkAIDerivation` submodule was found to be already present in the `.gitmodules` file.
- A shell script `tools/update_all_submodules.sh` was created and made executable to automate the update process for all submodules.
- The `update_all_submodules.sh` script was successfully tested.