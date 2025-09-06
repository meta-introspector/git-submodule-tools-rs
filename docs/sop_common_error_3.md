# Common Error 3: Direct File Editing and Deletion

**Description:** This error occurs when the agent (or any developer) directly modifies existing files or deletes them from the codebase without adhering to the project's principle of refactoring and versioning. This includes in-place edits that do not create a new version or a clear evolutionary path for the code.

**Project Principle:** In this project, direct deletion or in-place editing of files is strongly discouraged. Instead, every modification is considered an opportunity for refactoring and creating new, versioned iterations of the code. This approach ensures:
*   **Traceability:** A clear history of code evolution, allowing for easy rollback and understanding of changes.
*   **Auditability:** The ability to review and verify every stage of a component's lifecycle.
*   **Quality Improvement:** Encourages thoughtful refactoring and enhancement rather than quick fixes.
*   **Lattice Integrity:** Maintains the integrity of the project's conceptual "lattice" by preserving the historical states of its components.

**Mitigation/Resolution:**
1.  **Refactor, Don't Edit In-Place:** When a change is required, consider it a refactoring task. Create a new version of the component or function, incorporating the changes, and deprecate or clearly mark the old version for eventual removal in a structured manner.
2.  **Version Control:** Utilize the version control system (Git) to its fullest. Every significant change should result in a new commit, and major refactorings should be clearly documented in commit messages and potentially in dedicated CRQs.
3.  **Deprecation Strategy:** Implement a clear deprecation strategy for components that are being replaced. This might involve marking them as deprecated, providing migration paths, and eventually removing them in a planned release cycle.
4.  **Avoid `rm` and Direct Overwrites:** Unless explicitly instructed for temporary files or specific cleanup tasks, avoid using `rm` or directly overwriting files. Instead, use refactoring tools and version control to manage changes.
5.  **CRQ Adherence:** For significant refactorings or architectural changes, follow the Change Request (CRQ) process to ensure proper review and approval.
