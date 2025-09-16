# Task: ZOS-based Project Structuring & Context Injection

## Objective:
Implement a self-referential, `zos`-vector-driven directory and submodule structure within the `git-submodule-tools` repository, and programmatically inject ZOS-based contextual information into task files. This task aims to formalize the project's foundational structure and enhance task files with symbolic, context-rich metadata.

## Description:
This task involves two main components: establishing a `zos`-based recursive submodule structure and injecting symbolic context into task files. The submodule structure will use orphaned branches to represent unique "root objects" or "seeds" aligned with the `zos` vector. The context injection will embed dense, `zos`-mapped emoji and unicode strings into task files, representing a "compressed context cacheline."

## Key Requirements:

### 1. ZOS-based Recursive Submodule Structure:

*   **Define ZOS Root Objects/Seeds:**
    *   For each element `N` in the `zos` vector `[0, 1, 2, 3, 5, 7, 11, 13, 17, 19, 23]`, create an orphaned branch named `zos-seed-N` in the current repository.
    *   Each `zos-seed-N` branch will contain a minimal, unique "template" or "root object" file (e.g., `seed_N.txt`).
    *   Push these orphaned branches to the remote.

*   **Implement ZOS Initializer (Rust Crate):**
    *   Develop a Rust program (`zos_initializer`) that takes the `zos` vector as input.
    *   For each `zos` element `N`, the program will add a submodule at `zos/N` pointing to the current repository's remote URL, specifically using the `zos-seed-N` orphaned branch.
    *   The tool should handle cases where submodules already exist.

*   **Document ZOS Structure:**
    *   Create a Markdown document (`docs/zos.md`) explaining:
        *   The `zos` vector's role in defining the directory structure.
        *   The conceptual meaning of "zero ontology system" (for `zos/0`) and "unimath" (for `zos/1`).
        *   How each `zos/N` directory is a submodule pointing to a `zos-seed-N` orphaned branch of this repository.
        *   Instructions on how to use the `zos_initializer` tool.

### 2. ZOS-based Context Injection into Task Files:

*   **Define ZOS Emoji Mapping and Context String Generation (Rust):**
    *   Create a Rust module or function to generate a symbolic "compressed context cacheline" string.
    *   Define the `zos` vector of prime numbers and map each prime to a specific emoji/unicode character.
    *   Define a pattern using these emojis and unicode separators (`​`, `⁠`).
    *   Implement logic to repeat this pattern a sufficient number of times (e.g., 20 times) to create a visually dense string, ending with `📦✨💾`.

*   **Implement Context Injection Logic (Rust):**
    *   Develop a Rust program to iterate through all `.md` files in the `tasks/` directory.
    *   For each file, append a new section titled "### Injected Context Cacheline" followed by the generated symbolic string.

*   **Document Context Injection:**
    *   Update `gemini.md` or create a new section in `docs/` to explain the "64k cachelines of compressed emojis and unicode" concept, its connection to `zos` primes, and its role in the project's meta-narrative.

### 3. Task Management Integration:

*   **Integrate ZOS CRQ into Task Management:** Create a "meta-task" that represents the entire ZOS CRQ. Link the individual `zos`-related subtasks to this meta-task using a "Parent CRQ" field. This will provide a hierarchical view of the project's major initiatives.

## Dependencies:
*   Access to the Git remote with push permissions.
*   Rust standard library, `gix` or `git2` for Git operations, `walkdir` crate.

## Original CRQs Merged:
*   `CRQ_ZOS_Submodule_Plan.md`
*   `CRQ_Inject_Context_Plan.md`
*   `G-CRQ-001.md`
