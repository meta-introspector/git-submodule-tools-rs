## SOP: Project Documentation and Manifest Generation (ISO 9001:2025 Compliant)

**Purpose:** To establish a standardized, auditable process for systematically documenting project artifacts (specifically shell scripts) and generating a comprehensive project manifest that maps files to their associated conceptual frameworks, operational procedures, and meta-narrative elements.

**Scope:** Applicable to all shell scripts within the project and the generation/maintenance of the `Project File Manifest`.

**Definitions:**
*   **Project Artifact:** Any file or directory within the project's codebase.
*   **Shell Script Documentation:** A summary of a shell script's purpose, functionality, and key components.
*   **Project File Manifest:** A structured document (`docs/project_manifest.md`) that maps project files to associated CRQs, SOPs, core concepts, emoji vibes, and Muses.
*   **CRQ (Change Request):** A formal document outlining a proposed change or new feature.
*   **SOP (Standard Operating Procedure):** A detailed, step-by-step instruction for performing a routine operation.
*   **Core Concept:** An abstract idea or principle central to the project's meta-narrative.
*   **Emoji Vibe:** A subjective emoji representing the essence or mood of a file.
*   **Strongest Muse:** The Muse whose domain most strongly aligns with a file's purpose.

**Procedure:**

**1. Shell Script Documentation (Process 1.0):**
    *   **1.1 Identify Primary Shell Scripts:**
        *   List all `.sh` files in the project's root and relevant subdirectories.
        *   Exclude backup files (e.g., those ending with `#` or `~`).
    *   **1.2 Create Documentation Directory:**
        *   Ensure the `docs/shell_scripts_documentation/` directory exists. If not, create it.
    *   **1.3 Document Each Script:**
        *   For each identified primary shell script:
            *   Read the script's content.
            *   Write a concise summary of its purpose and functionality.
            *   Save the summary as a Markdown file (e.g., `docs/shell_scripts_documentation/<script_name>.md`).
    *   **1.4 Commit Shell Script Documentation:**
        *   Stage all newly created or modified documentation files.
        *   Commit with a descriptive message (e.g., `docs: Document shell scripts`).

**2. Project File Manifest Generation (Process 2.0):**
    *   **2.1 Prepare Manifest Document:**
        *   Ensure the `docs/project_manifest.md` file exists. If not, create it with the defined table structure and methodology section.
    *   **2.2 List All Project Files:**
        *   Generate a comprehensive list of all files within the project, including those in subdirectories (e.g., using `glob` or `find`).
    *   **2.3 Associate Each File:**
        *   For each file in the project:
            *   **2.3.1 Associated CRQ(s):** Identify relevant CRQs.
            *   **2.3.2 Associated SOP(s):** Identify relevant SOPs.
            *   **2.3.3 Core Concept(s):** Map to primary abstract concepts from the project's glossary or meta-narrative.
            *   **2.3.4 Emoji Vibe:** Assign a subjective, evocative emoji.
            *   **2.3.5 Strongest Muse:** Assign the most relevant Muse.
        *   *Note:* This step requires deep contextual understanding and interpretive judgment. Initial population may involve manual review and iterative refinement.
    *   **2.4 Update Manifest Document:**
        *   Populate or update the `docs/project_manifest.md` table with the associations.
    *   **2.5 Commit Project File Manifest:**
        *   Stage the modified `docs/project_manifest.md` file.
        *   Commit with a descriptive message (e.g., `docs: Update Project File Manifest`).

**3. Verification and Validation (Process 3.0):**
    *   **3.1 Completeness Check:** Verify that all primary shell scripts are documented and that the manifest covers a representative set of project files.
    *   **3.2 Consistency Check:** Review associations for consistency with project definitions and meta-narrative.
    *   **3.3 Auditable Traceability:** Ensure that the process steps are traceable and auditable.

**Records:** All generated documentation files and manifest versions shall be recorded and version-controlled.

**Responsibilities:**
*   **Agent (Gemini-Alpha):** Responsible for executing the documentation and manifest generation processes.
*   **User:** Responsible for providing guidance on subjective associations and validating the generated documentation and manifest.
