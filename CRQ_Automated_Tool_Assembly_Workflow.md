# CRQ: Automated Tool Assembly and Git Workflow

## Description

This CRQ defines a comprehensive, automated workflow for managing and synchronizing a sprawling ecosystem of nested Git repositories and Rust Cargo crates. The objective is to establish a "CRQ-driven development" paradigm where changes are initiated, tracked, committed, and synchronized across the entire codebase through a unified, intelligent process.

## Key Requirements

1.  **Crate-to-Git Mapping:**
    *   Develop a mechanism to scan all Rust Cargo crates within the project.
    *   For each identified crate, determine its containing Git repository (local or submodule).
    *   Generate a configuration or mapping that links each crate to its respective Git repository.

2.  **Dynamic Git Tool Configuration:**
    *   Integrate the generated crate-to-Git mapping into the configuration of our primary Git management tool (e.g., `submodule_manager` or a new dedicated tool). This configuration should enable the tool to operate on specific sets of repositories relevant to the crates being managed.

3.  **CRQ-Driven Workflow Initiation:**
    *   The entire workflow should be initiated by the creation of a new CRQ using the CRQ tool. This CRQ will serve as the central artifact for tracking the changes.

4.  **Intelligent Commit Message Generation:**
    *   Leverage AI assistance to generate a comprehensive and context-aware commit message that summarizes the changes being applied across all affected Git repositories. The commit message should reference the associated CRQ ID.

5.  **Atomic Multi-Repository Commit:**
    *   Execute a single command that performs `git add`, `git commit`, and optionally `git push` operations across all identified Git repositories (superproject and submodules) that contain changes related to the CRQ.
    *   Ensure that all repositories are committed together, maintaining a consistent state across the entire nested structure.

6.  **CRQ Update with Commit Details:**
    *   Automatically update the initiating CRQ document with details of the executed commits, including:
        *   The generated commit message.
        *   The commit hash for each affected Git repository.
        *   Links to the respective repositories or commits (if applicable).

7.  **Automated Crate Vendorization:**
    *   Implement a capability to automatically vendorize (copy source code into a `vendor/` directory) all Rust crates referenced in the CRQ or affected by the changes. This ensures self-contained builds and reduces external dependencies during specific phases of the development lifecycle.

## Rationale

This CRQ represents a significant leap towards fully automated and traceable software development within our complex Git and Rust ecosystem. By integrating crate scanning, dynamic tool configuration, CRQ-driven workflows, AI-assisted commit messaging, atomic multi-repository commits, and automated vendorization, we aim to:

*   Drastically reduce manual overhead and human error in managing large-scale changes.
*   Improve the integrity and synchronization of all nested repositories.
*   Enhance traceability and auditing of all code modifications.
*   Streamline the development and release processes for complex features.

## Out of Scope (for initial implementation)

*   Automated conflict resolution beyond basic Git capabilities.
*   Real-time monitoring of the automated workflow.
*   Integration with external issue tracking systems beyond referencing CRQ IDs.
*   Advanced dependency management beyond simple vendorization.

## Dependencies

*   Functional `submodule_manager` tool.
*   A robust CRQ tool (conceptual or actual).
*   Git command-line interface.
*   Rust Cargo build system.
*   AI model integration for commit message generation (requires further research and implementation).
