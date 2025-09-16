# Task: Podcast Episode Generator for Submodule Commits

## Objective:
Develop a tool that generates a text file representing a podcast episode script. This script will synthesize Git commit messages from selected submodules, grouping them thematically based on a defined "vibe" or conceptual coherence, and leveraging LLM text generation capabilities.

## Description:
This task involves creating an automated system to transform raw Git commit data from various submodules into a narrative podcast episode. The tool will analyze commit messages, identify underlying themes or "vibes" (e.g., related to specific features, bug fixes, or conceptual advancements), and then use an LLM to weave these commits into a coherent and engaging script. The output will be a plain text file suitable for a podcast transcript.

## Key Requirements:

1.  **Git Commit Data Extraction:**
    *   Ability to access and parse Git commit history from specified submodules.
    *   Extract relevant information from commits (e.g., message, author, date, affected files).

2.  **Thematic Grouping / "Vibe" Identification:**
    *   Implement logic to group commits that share a common "vibe" or thematic connection.
    *   This might involve keyword analysis, semantic similarity, or integration with existing project meta-data (e.g., CRQ IDs, meme concepts).

3.  **LLM Integration for Text Generation:**
    *   Research and integrate with existing LLM text generation tools or libraries available in Rust (Cargo), on GitHub, or integrated with Nix.
    *   The LLM will be responsible for transforming the grouped commit data into a narrative script.

4.  **Podcast Script Formatting:**
    *   Generate a structured text file that resembles a podcast episode script (e.g., including speaker cues, introductory/concluding remarks, transitions).

5.  **Output:**
    *   Produce a plain text file containing the generated podcast episode script.

## Research Focus (for LLM Text Generators):

*   **Cargo Ecosystem:** Search for Rust crates that provide LLM integration, text generation, or natural language processing capabilities.
*   **GitHub:** Look for open-source projects related to LLM text generation, especially those with Rust implementations or clear APIs.
*   **Nix Ecosystem:** Investigate how LLM tools are packaged or integrated within Nix, and if there are any Nix-native solutions for text generation.

## High-Level Architecture (Proposed):

1.  **Data Collector Module (Rust):** Responsible for cloning/updating submodules and extracting commit data.
2.  **Vibe Analyzer Module (Rust):** Processes commit messages to identify themes and group related commits.
3.  **LLM Orchestrator Module (Rust):** Interfaces with the chosen LLM (local or API-based) to feed grouped data and receive generated text.
4.  **Script Formatter Module (Rust):** Structures the LLM output into a podcast episode script.

## Deliverables:

*   A new task file (`prompts/Task-Podcast-Episode-Generator.md`).
*   Research findings on suitable LLM text generators.
*   A high-level architectural proposal for the podcast episode generator.
*   A list of actionable subtasks for implementing the tool.
