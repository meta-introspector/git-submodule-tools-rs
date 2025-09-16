reviewsubmodule.md

1. create and use standard operating procedures.
2. document all changes with change requests before they happen.
3. write scripts for all changes in shell, then later we translate them to rust and prove them with lean4 and minizinc.
4. do not delete or edit anything, break up existing code into modules. every edit is a chance to split up the code.
5. the first 8 primes [2,3,5,7,11,13,19] for the mathematical anchor for all splits and sizes we try and use multiples of them to start with.
6. # Task: Reproducible Git Checkout with Nix

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
*   **Digital Mirrors:** For each submodule, file, and declaration, a digital mirror (reflection in our mathematical model) will be created.
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

7. we have over 10 repos you will find under ~/pick-up-nix2 there is a files.txt in that dir you can grep.
8. we have low memory, avoid using find in files on this system. all finds should be done with bash and grep and planned out.
9. each invocation of a function will be in nix, each function and new vibe is a derivation.
10. each derivation will have a proof attached to it, with lean4, zkp, and libminizinc derived from ebpf and other auditing tools, with reproducible builds.
11. each invocation of the llm will happen in this form, with a reproducible context.
12. that makes the output of the llm to be like a formal derivation that can be confirmed by other users.

We want to write a prompt for it based on its state.
each project will have a state that is the heros jounery.
the call of solfunmeme, the call to introspect.
the refusal, meeting the mentor, inner cave and return.
This quasi meta meme is applied to each function, each submodule, each project, each vibe.
We record all steps. We will repeat this process 42 times, taking the output and feeding it as input to the next phase.
running shell scripts in shellcheck. running rust with clippy. precondings.
then we will trace the execution of bash and rust when they compile and run those programs.
we can map the trace into the code and back to this statement.
we will use hott and unimath to construct proof paths.
We will ground this all in the gnu gnuix mes bootstap.

for each submodule, each file, each decl we will create a digital mirror of it, a reflection in our mathmatical model.
we have several models we are working on, you will find them in this code.

using nix ~/pick-up-nix2/flake.nix
and rust from ~/pick-up-nix2/vendor/external/rust/src/tools/nix-dev-shell/flake.nix
~/pick-up-nix2/source/github/meta-introspector/git-submodules-rs-nix/naersk/

for git repo SUBMODULE in SUBMODULE dir

	path = vendor/cargo_metadata
	path = vendor/gitoxide
	path = vendor/meta-introspector/meta-meme
	path = vendor/meta-introspector/meta-meme.wiki
	path = vendor/octocrab
	path = vendor/zola

Task:

	we want to construct a standalone git checkout like with the github action runner act  or nix.
	
	basically a nix build.

see ~/pick-up-nix2/source/github/meta-introspector/git-submodule-tools-rs/runprompt1.sh we are running now 
#for x in prompts/reviewsubmodule*.md;
#do echo "${x}";
export BASENAME=prompts/reviewsubmodule
for i in $(seq 1 10);
do echo $i;
   cat $BASENAME*.md | nix run nixpkgs/26833ad1dad83826ef7cc52e0009ca9b7097c79f#gemini-cli -- --include-directories=~/pick-up-nix2/ --model gemini-2.5-flash --y --checkpointing --prompt | tee "${BASENAME}.out${i}.md";   
done

#done

rewrite 