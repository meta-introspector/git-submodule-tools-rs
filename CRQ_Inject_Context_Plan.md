## CRQ: Inject ZOS-based Context into Task Files

**Objective:** To programmatically inject a symbolic "compressed context cacheline" string, representing dense information encoded with `zos`-mapped emojis and unicode, into each task file (`tasks/*.md`).

**High-Level Steps (for Gemini Agent):**

1.  **Subtask 1.1: Define ZOS Emoji Mapping and Context String Generation (Rust).**
    *   **Objective:** Create a Rust module or function to generate the symbolic "compressed context cacheline" string.
    *   **Description:**
        *   Define the `zos` vector of prime numbers.
        *   Map each prime number to a specific emoji/unicode character.
        *   Define a pattern using these emojis and unicode separators (`\u200B`, `\u2060`).
        *   Implement logic to repeat this pattern a sufficient number of times (e.g., 20 times) to create a visually dense string, ending with `📦✨💾`.
    *   **Scope:** New Rust code within `crates/zos_initializer` or a new utility crate.
    *   **Acceptance Criteria:**
        *   A Rust function exists that, when called, returns the desired symbolic "compressed context cacheline" string.
        *   The string contains the correct emojis mapped to `zos` primes and appropriate unicode separators.
        *   The string is of a reasonable length (e.g., 200-300 characters) to convey "packed data."
    *   **Dependencies:** Rust standard library.
    *   **Assigned Agent:** Gemini (Self-assigned)
    *   **Status:** To Do
    *   **Notes:** Focus on symbolic representation, not literal data compression.

2.  **Subtask 1.2: Implement Context Injection Logic (Rust).**
    *   **Objective:** Develop a Rust program to read, modify, and write back each task file with the injected context.
    *   **Description:**
        *   The program will iterate through all `.md` files in the `tasks/` directory.
        *   For each file:
            *   Read its current content.
            *   Append a new section titled "### Injected Context Cacheline" followed by the generated symbolic string (from Subtask 1.1).
            *   Write the modified content back to the file.
    *   **Scope:** Rust code within `crates/zos_initializer` or a new utility crate.
    *   **Acceptance Criteria:**
        *   The Rust program compiles and runs successfully.
        *   After execution, every `.md` file in `tasks/` contains the new "### Injected Context Cacheline" section with the correct symbolic string appended to its end.
        *   The original content of the task files remains intact.
    *   **Dependencies:** Subtask 1.1 completed (context string generation function available), `walkdir` crate for iterating files.
    *   **Assigned Agent:** Gemini (Self-assigned)
    *   **Status:** To Do
    *   **Notes:** Ensure robust file I/O and error handling.

3.  **Subtask 1.3: Document Context Injection (Rust).**
    *   **Objective:** Document the process and meaning of the injected context.
    *   **Description:** Update `gemini.md` or create a new section in `docs/` to explain the "64k cachelines of compressed emojis and unicode" concept, its connection to `zos` primes, and its role in the project's meta-narrative.
    *   **Scope:** Markdown documentation.
    *   **Acceptance Criteria:**
        *   The documentation clearly explains the symbolic nature and purpose of the injected context.
        *   It links the emojis to the `zos` primes.
        *   It reinforces the meta-narrative aspects.
    *   **Dependencies:** Subtask 1.2 completed (context injected).
    *   **Assigned Agent:** Gemini (Self-assigned)
    *   **Status:** To Do
    *   **Notes:** This is crucial for explaining the "why" behind this unusual feature.
