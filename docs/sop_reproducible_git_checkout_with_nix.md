# Standard Operating Procedure: Reproducible Git Checkout with Nix

## Objective:
Construct a standalone and reproducible Git checkout environment, similar to how `act` (GitHub Actions runner) or Nix handles isolated builds. This essentially involves creating a Nix build that can reliably check out a Git repository and its submodules.

## Project Principles for Task Execution:

1.  **Standard Operating Procedures (SOPs):** All processes must be defined and executed via SOPs.
2.  **Change Requests (CRQs):** Document all changes with CRQs before implementation.
3.  **Scripting First:** Implement all changes using shell scripts initially. These scripts will later be translated to Rust, formally proven with Lean4, and verified with MiniZinc.
4.  **Modularization:** Avoid deleting or directly editing existing code. Instead, break down existing code into smaller, modular components. Every modification is an opportunity for code splitting.
5.  **Mathematical Anchoring for Splits:** Utilize the first 8 prime numbers (2, 3, 5, 7, 11, 13, 17, 19) as mathematical anchors for all code splits and sizing decisions, aiming for multiples of these primes.
6.  **Efficient Submodule Status:** Replace slow `git submodule status` with `git submodule status --ignore-submodules` for improved performance.
7.  **Project Context:** The project includes over 10 repositories located under `~/pick-up-nix2`. A `files.txt` in that directory can be grepped for relevant information.
8.  **Memory Constraints:** Operate under low memory conditions. Avoid `find` commands; all file searches should be planned and executed using `bash` and `grep`.
9.  **Nix-based Functions:** Each function invocation will be managed by Nix, with each function and conceptual "vibe" treated as a Nix derivation.
10. **Formal Proofs for Derivations:** Each Nix derivation will have an attached formal proof, utilizing Lean4, Zero-Knowledge Proofs (ZKP), and LibMiniZinc, derived from eBPF and other auditing tools, ensuring reproducible builds.
11. **Reproducible LLM Invocations:** All LLM invocations will follow a reproducible context, ensuring consistent output.
12. **Verifiable LLM Output:** The output of the LLM will be structured as a formal derivation, allowing for confirmation by other users.

## Contextual Information:

*   **Hero's Journey Meta-Meme:** Each project, function, submodule, and conceptual "vibe" is viewed through the lens of the Hero's Journey (Call of Solfunmeme, Refusal, Meeting the Mentor, Inner Cave, Return). All steps are recorded, and this process will be repeated 42 times, with the output feeding into the next phase.
*   **Code Quality Checks:** Shell scripts will be run through ShellCheck, and Rust code with Clippy.
*   **Execution Tracing:** Execution of Bash and Rust (compilation and runtime) will be traced using `strace`. These traces will be mapped back to the code and the initial statement.
*   **Proof Paths:** HoTT (Homotopy Type Theory) and Unimath will be used to construct proof paths.
*   **Bootstrapping:** The entire system will be grounded in the GNU Guix Mes bootstrap.
*   **Digital Mirrors:** For each submodule, each file, each declaration, a digital mirror (reflection in our mathematical model) will be created.
*   **Nix and Rust Toolchains:**
    *   Nix: `~/pick-up-nix2/flake.nix`
    *   Rust: `~/pick-up-nix2/vendor/external/rust/src/tools/nix-dev-shell/flake.nix`
    *   Naersk: `~/pick-up-nix2/source/github/meta-introspector/git-submodules-rs-nix/naersk/`

## Relevant Submodules (Examples):

*   `vendor/cargo_metadata`
*   `vendor/gitoxide`
*   `vendor/meta-introspector/meta-meme`
*   `vendor/meta-introspector/meta-meme.wiki`
*   `vendor/octocrab`
*   `vendor/zola`