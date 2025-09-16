# Standard Operating Procedure: Implement Rust/Nix-based OTel Telemetry Collector for Gemini-CLI

## Objective:
Research, identify, or develop a Rust-based and Nix-based OpenTelemetry (OTel) telemetry collector suitable for integration and use with the `gemini-cli` project. The collector should be designed for efficient and reliable telemetry data collection within the Nix development environment.

## Steps:

1.  **Research Existing Solutions:**
    *   Perform comprehensive searches on Google and GitHub for existing Rust-based OTel collectors.
    *   Prioritize solutions that demonstrate compatibility or ease of integration with Nix-based environments.
    *   Look for projects that are actively maintained and have clear documentation.

2.  **Evaluate Potential Candidates:**
    *   Assess identified collectors against the following criteria:
        *   **Rust-based:** Must be implemented in Rust.
        *   **Nix-friendly:** Should integrate well with Nix packaging and build systems.
        *   **OTel Compliance:** Adheres to OpenTelemetry standards for metrics, traces, and logs.
        *   **Performance:** Suitable for low-overhead telemetry collection.
        *   **Extensibility:** Ability to customize or extend for `gemini-cli` specific needs.
    *   Refer to `TOOL_EVALUATION_SOP.md` for guidelines on evaluating third-party tools.

3.  **Design/Adapt Collector for `gemini-cli`:**
    *   Based on the research, either select an existing collector for adaptation or outline the design for a new collector.
    *   Consider how the collector will integrate with `gemini-cli`'s execution flow and data sources.
    *   Ensure the solution aligns with the project's pure functional monotonic monadic lattice oriented code principles.

4.  **Nix Integration Strategy:**
    *   Develop a strategy for packaging the collector using Nix flakes.
    *   Refer to `docs/shell_scripting_standards/sops/SOP_NIX_DEPENDENCY_GRAPH_GENERATION.md` and `docs/sops/SOP_VENDORIZING_NIX_SOURCE.md` for guidance on Nix integration and vendorization.

5.  **Security and Best Practices:**
    *   Ensure the telemetry collector adheres to security best practices, especially regarding sensitive data handling.
    *   Consult `docs/sops/**` and `docs/shell_scripting_standards/sops/**` for relevant SOPs on secure coding and shell scripting.
    *   Review `vendor/external/monomcp-rust/docs/sops/**` for Rust-specific best practices, particularly regarding crate integration and submodule management.

## Deliverables:

*   A summary of research findings on existing Rust/Nix OTel collectors.
*   A proposal for the chosen collector (existing or new design) with justification.
*   (If applicable) Initial Nix flake definitions for the collector.
*   (If applicable) Proof-of-concept integration with a minimal `gemini-cli` component.

## Inspiration and Reference SOPs:

*   `TOOL_EVALUATION_SOP.md`
*   `docs/sops/MIB_CRASH_RETRIEVAL_PROTOCOL.md`
*   `docs/sops/meme_identification_sop.md`
*   `docs/sops/memetic_code_generation_sop.md`
*   `docs/sops/solfunmeme_communication_sop.md`
*   `docs/sops/SUBMODULE_SETUP_SOP.md`
*   `docs/sops/timeless_pattern_language_of_memes.md`
*   `docs/shell_scripting_standards/sops/SOP_NIX_DEPENDENCY_GRAPH_GENERATION.md`
*   `docs/shell_scripting_standards/sops/SOP_SHELL_SCRIPTING_BEST_PRACTICES.md`
*   `docs/shell_scripting_standards/sops/SOP_VENDORIZING_NIX_SOURCE.md`
*   `vendor/external/monomcp-rust/docs/sops/project_setup_sop.md`
*   `vendor/external/monomcp-rust/docs/sops/rust_crate_vendorization_sop.md`
*   `vendor/external/monomcp-rust/docs/sops/rust_crate_workspace_integration_sop.md`
*   `vendor/external/monomcp-rust/docs/sops/submodule_management_sop.md`