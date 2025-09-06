# Standard Operating Procedure: Documenting Common Commands and Errors

## Common Errors:

### Error 1: "You forgot to save your amazing work."

**Description:** This error occurs when the agent generates content (e.g., a poem, a report) but fails to save it to a file before proceeding to other tasks or receiving a new instruction. This results in the loss of the generated content.

**Mitigation/Resolution:**
1.  **Immediate Action:** If the content is still in the agent's active memory or output buffer, immediately use the `write_file` tool to save it to a designated file path.
2.  **Proactive Saving:** Develop a habit of explicitly saving any generated content that is intended to be persistent or reviewed later. Consider saving intermediate outputs even if the final destination is not yet determined.
3.  **User Confirmation:** If unsure whether content needs to be saved, ask the user for clarification.

### Error 2: "You did not write and follow a SOP/CRQ/QA in our ISO9K, GMP, ITIL, 6Sigma, C4, UML, Agile, Extreme, FLOSS, ZKP, Lean4, MiniZinc system."

**Description:** This error signifies a critical deviation from the project's mandated quality, process, and architectural frameworks. It indicates a failure to either create, adhere to, or properly document Standard Operating Procedures (SOPs), Change Request (CRQ) processes, or Quality Assurance (QA) protocols within the established system. The system is defined by a comprehensive set of methodologies and standards, including ISO9K, Good Manufacturing Practices (GMP), ITIL, 6Sigma, C4 architecture, UML, Agile, Extreme Programming, Free/Libre Open Source Software (FLOSS) principles, Zero-Knowledge Proofs (ZKP), Lean4, and MiniZinc.

**Implications:** Such a failure can lead to:
*   Inconsistent development practices.
*   Reduced project quality and reliability.
*   Lack of traceability and auditability.
*   Increased technical debt and maintenance burden.
*   Compromised security and compliance.

**Mitigation/Resolution:**
1.  **Immediate Review:** Halt current operations and immediately review the relevant project documentation (e.g., `CRQ_*.md` files, `SOP_*.md` files, `docs/qa/` directory) to understand the applicable framework.
2.  **Process Adherence:** Strictly follow the defined steps for CRQs, SOPs, and QA. This includes:
    *   **CRQ:** Submitting a formal Change Request for any significant modification or new feature.
    *   **SOP:** Adhering to established Standard Operating Procedures for routine tasks.
    *   **QA:** Implementing and verifying changes against defined Quality Assurance criteria.
3.  **Documentation:** Ensure all actions, decisions, and their justifications are thoroughly documented within the appropriate framework (e.g., updating task files, creating new SOPs, logging QA results).
4.  **Clarification:** If any part of the framework is unclear, seek immediate clarification from the user or consult existing project guidelines.
5.  **Proactive Integration:** Integrate these principles into every aspect of the development workflow, rather than treating them as optional steps.

## SOP Creation Process:

This Standard Operating Procedure document is being created through an interactive, iterative process between the user and the Gemini agent. The user provides common commands and errors encountered during development, and the agent is responsible for documenting them in a structured format within this SOP. This process ensures that the SOP is directly relevant to real-world development challenges and evolves with the project's needs.

**Workflow:**
1.  **User Input:** The user identifies a common command or error and communicates it to the agent.
2.  **Agent Documentation:** The agent adds a new section to this SOP, detailing the command/error, its description, implications (if any), and mitigation/resolution steps.
3.  **Iterative Refinement:** The process repeats, with the user providing further inputs and the agent continuously updating and refining the SOP.
4.  **Commit and Push:** Periodically, the agent commits the updated SOP to the version control system to ensure persistence and traceability.
