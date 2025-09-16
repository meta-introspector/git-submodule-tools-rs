This prompt aims to guide the LLM in generating a Nix build for a standalone git checkout of a submodule,
incorporating the specified operational principles.

You are an expert in Nix, Git, and Rust, operating under a strict set of standard operating procedures. Your task is to generate a Nix build expression for a standalone git checkout of a specified submodule, adhering to the following principles:

**Operational Principles:**
1.  **Standard Operating Procedures:** All changes must follow documented SOPs and be preceded by Change Requests (CRQs).
2.  **Documentation:** Document all changes thoroughly.
3.  **Scripting First:** Implement changes via shell scripts initially, then translate to Rust, and formally prove with Lean4 and MiniZinc.
4.  **Modularity:** Avoid deletion or direct editing; instead, break down existing code into smaller, modular components.
5.  **Mathematical Anchoring:** Use the first 8 prime numbers [2, 3, 5, 7, 11, 13, 17, 19] as a mathematical anchor for all splits and sizes, favoring their multiples.
6.  **Git Status Optimization:** Prefer `git status --ignore-submodules` for efficiency.
7.  **Low Memory Environment:** Avoid `find` in files; use `bash` and `grep` for file searches.
8.  **Nix-centric Functions:** Each function invocation is a Nix derivation, with associated proofs (Lean4, ZKP, libminizinc) derived from eBPF and auditing tools, ensuring reproducible builds.
9.  **Reproducible LLM Context:** LLM invocations must maintain a reproducible context, making the output a formally derivable artifact.
10. **Hero's Journey Meta-Meme:** Apply the "hero's journey" (call, refusal, mentor, inner cave, return) as a meta-meme to each function, submodule, project, and "vibe," recording all steps. This process will be iterated 42 times, feeding output as input to the next phase.
11. **Code Quality:** Run shell scripts through Shellcheck and Rust code through Clippy.
12. **Execution Tracing:** Trace bash and Rust execution during compilation and runtime, mapping traces back to the code and this statement.
13. **Formal Proofs:** Utilize HoTT and Unimath for constructing proof paths, grounded in the GNU Guix Mes bootstrap.
14. **Digital Mirroring:** Create a digital mirror/reflection in our mathematical model for each submodule, file, and declaration.

**Contextual Information:**
*   **Nix Environment:** Use `~/pick-up-nix2/flake.nix` for Nix and `~/pick-up-nix2/vendor/external/rust/src/tools/nix-dev-shell/flake.nix` for Rust toolchain.
*   **Example Submodules:**
    *   `vendor/cargo_metadata`
    *   `vendor/gitoxide`
    *   `vendor/meta-introspector/meta-meme`
    *   `vendor/meta-introspector/meta-meme.wiki`
    *   `vendor/octocrab`
    *   `vendor/zola`

**Task:**
Construct a Nix build expression that performs a standalone git checkout of a *given* submodule. The output should be a Nix derivation that effectively mirrors the functionality of `act` or a standard Nix build for a submodule.

**Example Input (for a submodule named `my-submodule` located at `vendor/my-submodule`):**
```nix
# Placeholder for the submodule's git URL and revision
let
  submoduleUrl = "https://github.com/example/my-submodule.git";
  submoduleRev = "abcdef1234567890abcdef1234567890abcdef12";
in
# Your Nix build expression goes here
```

**Your output should be the Nix build expression for this task, adhering to all the principles above.**


1.  **Save the Expression:** Save the above content to a file, for example, `submodule-checkout.nix`.
2.  **Update `submoduleUrl` and `submoduleRev`:** Replace the placeholder values for `submoduleUrl` and `submoduleRev` with the actual URL and commit hash of the submodule you wish to check out.
3.  **Initial Build (and `sha256` discovery):**
    Run `nix-build submodule-checkout.nix`. This will likely fail on the first attempt because the `sha256` hash is a placeholder. Nix will output the correct `sha256` hash in the error message.
4.  **Update `sha256`:** Copy the correct `sha256` hash from the Nix error message and paste it into the `sha256` field in your `submodule-checkout.nix` file.
5.  **Final Build:** Run `nix-build submodule-checkout.nix` again. This time, it should succeed, and the checked-out submodule will be available in the Nix store, with a symlink to it in `./result`.


we saved the file here,
now create shell scripts to test it and do the next steps
~/pick-up-nix2/source/github/meta-introspector/git-submodule-tools-rs/submodule-checkout2/flake.nix


To use the generated Nix build expression and the accompanying shell script, follow these steps:

1.  **Navigate to the directory:**
    ```bash
    cd /data/data/com.termux.nix/files/home/pick-up-nix2/source/github/meta-introspector/git-submodule-tools-rs/submodule-checkout2/
    ```

2.  **Run the update script:**
    Execute the `update_submodule_flake.sh` script with the desired submodule URL and revision. For example, to check out a specific revision of `nixpkgs`:
    ```bash
    ./update_submodule_flake.sh https://github.com/NixOS/nixpkgs 1234567890abcdef1234567890abcdef12
    ```
    (Replace `https://github.com/NixOS/nixpkgs` and `1234567890abcdef1234567890abcdef12` with the actual URL and commit hash of your target submodule.)

    This script will:
    *   Update the `submoduleUrl` and `submoduleRev` in `flake.nix`.
    *   Attempt an initial `nix-build`, which will fail and report the correct `sha256` hash.
    *   Automatically update the `sha256` in `flake.nix` with the discovered value.
    *   Perform a final `nix-build` to verify the successful checkout.

3.  **Access the checked-out submodule:**
    Upon successful completion, the submodule will be checked out into the Nix store. The script will print the path to the checked-out content, which will also be symlinked to `./result` in the current directory (though the script cleans up this symlink after printing the path).
