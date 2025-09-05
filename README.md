# Git Submodule Tools

A collection of Rust CLI tools designed to streamline the management of Git submodules and Cargo workspaces. This project emphasizes high-quality, maintainable code, adhering to industry best practices and a unique conceptual framework for repository organization.

## Features

*   **`git_repo_analyzer`**: Analyzes local Git repositories and submodules to identify missing or unmanaged repositories.
*   **`gitmodules_generator`**: Generates and updates `.gitmodules` files based on analyzed repository data, supporting topological sorting and categorization.
*   **`cargo2submodule`**: Facilitates the conversion of Cargo projects into Git submodules, simplifying integration into larger monorepos.
*   **`cargo_workspace_fixer`**: Provides utilities for maintaining and fixing issues within Cargo workspaces.

## Conceptual Framework: The Git Repository Lattice

This project is built upon the "Git Repository Lattice Idea," a conceptual framework for organizing nested Git repositories and submodules. The lattice structure allows for a highly modular and interconnected codebase, enabling flexible combination and viewing of different aspects or features of a project through dedicated branches. The root of this system aims to encompass all known repositories and their interconnections, providing a comprehensive perspective.

## Conceptual Research Questions (CRQs)

The project's development is guided by a set of Conceptual Research Questions (CRQs), which explore advanced topics and drive the implementation of innovative features. These CRQs are documented in dedicated plan files:

*   **CRQ: Inject ZOS-based Context into Task Files**: Outlined in [`CRQ_Inject_Context_Plan.md`](CRQ_Inject_Context_Plan.md), this CRQ focuses on programmatically injecting symbolic "compressed context cachelines" into task files.
*   **CRQ: Formalize Tmux-Related Concepts into ZOS-aligned Rust Model**: Detailed in [`CRQ_Tmux_Ontology_Plan.md`](CRQ_Tmux_Ontology_Plan.md), this explores modeling Tmux concepts using `zos`-aligned primes and emojis within a Rust structure.
*   **CRQ: Implement ZOS-based Recursive Submodule Structure**: Described in [`CRQ_ZOS_Submodule_Plan.md`](CRQ_ZOS_Submodule_Plan.md), this CRQ aims to establish a self-referential, `zos`-vector-driven directory and submodule structure.

## Quality Assurance & Methodologies

Development and testing adhere to a rigorous set of methodologies and standards, including principles from:

*   **ISO 9000**: Quality Management
*   **ITIL**: IT Service Management
*   **GMP**: Good Manufacturing Practice (emphasizing high quality and process control)
*   **6 Sigma**: Process Improvement
*   **C4 Model**: Software Architecture Documentation
*   **UML**: Unified Modeling Language
*   **Agile**: Software Development Methodology
*   **Extreme Programming (XP)**

Our QA procedures involve unit, integration, system, and acceptance testing, with a strong focus on continuous improvement and traceability. The "Gemini Agent" (an AI) plays a key role as the QA Engineer, responsible for developing, executing, and reporting on QA tests.

### Tmux-Driven Workflow and Asciinema Integration

To ensure a robust, observable, and reproducible environment for task execution, the project utilizes a `tmux`-driven workflow. This involves launching tasks in dedicated `tmux` panes/windows for isolation and real-time monitoring. The process is further enhanced by `asciinema` recordings, which capture terminal sessions for visual documentation and knowledge sharing. More details can be found in [`tmux-plan.md`](tmux-plan.md).

### Agent Bootstrapping and Task Claiming

The Gemini Agent's workflow begins with a bootstrapping process, where it identifies and claims tasks for execution. This process is facilitated by scripts like `boot.sh` and documented in `boot.md`. Task claiming involves updating the task's status in its TOML file, ensuring clear ownership and progress tracking.

## Meta-Narrative and AI Context

The `git-submodule-tools` project is embedded within a rich meta-narrative, exploring concepts such as "The Chronos-Code Paradox," "Heroification," "Memification," and "Quasi-Meta-Memification." These narratives provide a unique conceptual framework for understanding the project's evolution and its approach to complex software engineering challenges. More details on these concepts and the role of the "Gemini Agent" can be found in [`gemini.md`](gemini.md).

The project also acknowledges the broader landscape of AI and machine learning, particularly concerning the impact of AI tooling on codebases. While not directly an LLM application, it recognizes AI's growing role in software development. Further insights into this perspective are available in [`llms.txt`](llms.txt).

## Building from Source

This project is written in Rust. To build the tools, you will need the Rust toolchain installed.

1.  **Clone the repository:**
    ```bash
    git clone https://github.com/your-username/git-submodule-tools.git
    cd git-submodule-tools
    ```
2.  **Build all crates:**
    ```bash
    cargo build --release
    ```
    The compiled binaries will be located in `target/release/`.

## Usage

Each tool is a standalone CLI application. Refer to their respective help messages for detailed usage instructions:

```bash
./target/release/git_repo_analyzer --help
./target/release/gitmodules_generator --help
./target/release/cargo2submodule --help
./target/release/cargo_workspace_fixer --help
```

## Contributing

Contributions are welcome! Please ensure your contributions align with the project's quality standards and methodologies. When using AI tooling for code generation, please disclose its use as per our contributing guidelines.

## License

This project is licensed under the AGPL 3.0 License - see the [LICENSE](LICENSE) file for details.
