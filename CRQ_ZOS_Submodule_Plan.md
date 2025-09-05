## CRQ: Implement ZOS-based Recursive Submodule Structure

**Objective:** To establish a self-referential, `zos`-vector-driven directory and submodule structure within the `git-submodule-tools` repository, where each `zos` element corresponds to a submodule pointing to an orphaned branch of the same repository, representing a unique "root object" or "seed."

**High-Level Steps (for Gemini Agent):**

1.  **Define ZOS Root Objects/Seeds:**
    *   **Subtask 1.1: Create Orphaned Branches for ZOS Seeds.**
        *   **Objective:** Prepare the necessary "root object" branches for the `zos` submodules.
        *   **Description:** For each element `N` in the `zos` vector `[0, 1, 2, 3, 5, 7, 11, 13, 17, 19, 23]`, create an orphaned branch named `zos-seed-N`. Each `zos-seed-N` branch will contain a minimal, unique "template" or "root object" file (e.g., `seed_N.txt`). Push these orphaned branches to the remote.
        *   **Scope:** Git repository operations (branch creation, file creation, commit, push).
        *   **Acceptance Criteria:**
            *   For each `N` in `zos_vector`, a remote branch `zos-seed-N` exists.
            *   Each `zos-seed-N` branch contains a file `seed_N.txt` with unique content.
        *   **Dependencies:** Access to the Git remote with push permissions.
        *   **Assigned Agent:** Gemini (Self-assigned)
        *   **Status:** To Do
        *   **Notes:** This will be implemented using a Rust program.

2.  **Implement ZOS Initializer (Rust Crate):**
    *   **Subtask 2.1: Develop `zos_initializer` Rust Crate.**
        *   **Objective:** Automate the process of adding the `zos` submodules.
        *   **Description:** Develop a Rust program that takes the `zos` vector as input. For each `zos` element `N`, it will add a submodule at `zos/N` pointing to the current repository's remote URL, specifically using the `zos-seed-N` orphaned branch.
        *   **Scope:** New Rust crate (`crates/zos_initializer`), using `gix` or `git2` for Git operations, and Rust's standard library for file system operations.
        *   **Acceptance Criteria:**
            *   The `zos_initializer` Rust program compiles and runs successfully.
            *   After execution, the `.gitmodules` file is correctly updated with entries for each `zos` submodule.
            *   The `zos/` directories are created and contain the correct submodule checkouts.
            *   The submodules correctly point to their respective `zos-seed-N` orphaned branches.
        *   **Dependencies:** Subtask 1.1 completed (orphaned branches exist).
        *   **Assigned Agent:** Gemini (Self-assigned)
        *   **Status:** To Do
        *   **Notes:** The tool should handle cases where submodules already exist.

3.  **Document ZOS Structure:**
    *   **Subtask 3.1: Create `docs/zos.md` Documentation.**
        *   **Objective:** Clearly explain the `zos` vector-based directory and submodule structure.
        *   **Description:** Create a Markdown document (`docs/zos.md`) that explains:
            *   The `zos` vector's role in defining the directory structure.
            *   The conceptual meaning of "zero ontology system" (for `zos/0`) and "unimath" (for `zos/1`).
            *   How each `zos/N` directory is a submodule pointing to a `zos-seed-N` orphaned branch of this repository.
            *   Instructions on how to use the `zos_initializer` tool to set up and update this structure.
        *   **Scope:** New Markdown file in `docs/`.
        *   **Acceptance Criteria:**
            *   `docs/zos.md` is created and contains all required information.
            *   The explanation is clear, concise, and accurate.
            *   The document is integrated into the project's overall documentation (e.g., linked from `README.md` if appropriate).
        *   **Dependencies:** Subtask 2.1 completed (tool exists).
        *   **Assigned Agent:** Gemini (Self-assigned)
        *   **Status:** To Do
        *   **Notes:** Emphasize the meta-narrative aspects.
