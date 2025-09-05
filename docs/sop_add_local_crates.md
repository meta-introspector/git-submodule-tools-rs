Standard Operating Procedure: Adding New Local Crates to the Workspace

Purpose: This SOP outlines the process for integrating Rust crates that are not published to `crates.io` but exist locally (e.g., in another workspace) into the current project's workspace. This method utilizes Cargo's `[patch.crates-io]` feature to treat local crates as if they were published dependencies.

Scope: This SOP applies to developers working within the `git-submodule-tools` project who need to incorporate local Rust crates as dependencies.

Procedure:

1.  **Identify the Local Crate(s):**
    *   Determine the absolute path to the root directory of the local crate you wish to add (e.g., `/path/to/your/local_crate`).
    *   Read the `Cargo.toml` of the local crate to identify its `name` and `version`.
    *   Note any *path dependencies* that the local crate itself has. These will also need to be patched.

2.  **Update the Root `Cargo.toml` (`git-submodule-tools/Cargo.toml`):**
    *   Open the `Cargo.toml` file at the root of the `git-submodule-tools` project.
    *   Locate or create the `[patch.crates-io]` section.
    *   For each local crate you want to add, and for each of its *path dependencies*, add an entry in the `[patch.crates-io]` section. The format is:
        ```toml
        [patch.crates-io]
        crate_name = { path = "relative/path/to/local/crate" }
        ```
        *   `crate_name`: The `name` field from the local crate's `Cargo.toml`.
        *   `relative/path/to/local/crate`: The path to the local crate's root directory, *relative to the `git-submodule-tools/Cargo.toml` file*. Carefully calculate this path, considering the directory structure.

    *   **Example:** If `git-submodule-tools` and `another_repo` are siblings, and `my_crate` is in `another_repo/crates/my_crate`, the entry would be:
        ```toml
        my_crate = { path = "../another_repo/crates/my_crate" }
        ```

3.  **Add the Local Crate as a Dependency to a Consumer Crate:**
    *   Identify the crate within the `git-submodule-tools` workspace that will use the functionality of the newly added local crate (e.g., `crates/zos_initializer`).
    *   Open the `Cargo.toml` of this consumer crate.
    *   In its `[dependencies]` section, add the local crate as a regular versioned dependency, using the `name` and `version` identified in Step 1. Cargo will automatically resolve this to the patched local path.
        ```toml
        [dependencies]
        # ... other dependencies
        local_crate_name = { version = "0.1.0" } # Use the actual version from the local crate's Cargo.toml
        ```

4.  **Build and Test the Workspace:**
    *   Navigate to the root of the `git-submodule-tools` project in your terminal.
    *   Run `cargo build` to ensure all dependencies are resolved and the project compiles.
    *   Run `cargo test --workspace` to execute all tests and verify functionality.
    *   Address any compilation errors or test failures. Common issues include incorrect relative paths in `[patch.crates-io]` or missing transitive dependencies.

5.  **Commit Changes:**
    *   Once the build and tests pass, stage the modified `Cargo.toml` files (root and consumer crate).
    *   Commit the changes with a clear and concise message describing the added crates and their purpose.

**Important Considerations:**

*   **Binary vs. Library Crates:** Remember that you cannot directly depend on a binary crate as a library. If the local crate is a binary, you might need to refactor it to expose a library target (`src/lib.rs`) or interact with it by executing its binary.
*   **Transitive Dependencies:** Ensure all transitive path dependencies of the local crate are also patched in the root `Cargo.toml`.
*   **Version Compatibility:** While `[patch.crates-io]` redirects to a local path, ensure the version specified in the consumer crate's `[dependencies]` is compatible with the local crate's version.
