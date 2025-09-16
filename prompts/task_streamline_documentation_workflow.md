## Task: Streamline Documentation Workflow

### Referenced SOPs:
*   [SOP: Streamline Documentation Workflow](docs/sop_streamline_documentation_workflow.md)

### Referenced CRQs:
*   [CRQ: Standardize Task Documentation with SOPs and CRQs](CRQ_Standardize_Task_Documentation_with_SOPs_and_CRQs.md)

This task outlines the standard operating procedures for streamlining the documentation workflow.

--- Appended Content from prompts/task_streamline_documentation_workflow.md.out1.md (truncated) ---
Okay, I have read the prelude and understand the context. I will now proceed with the task to "Streamline Documentation Workflow."

First, I will read the referenced SOP and CRQ documents to understand the current state and goals.`read_many_files` couldn't find the files. I'll use `glob` to verify `sop_streamline_documentation_workflow.md` in `docs/` and get the correct path.`sop_streamline_documentation_workflow.md` is there. Now, `CRQ_Standardize_Task_Documentation_with_SOPs_and_CRQs.md` in root.`CRQ_Standardize_Task_Documentation_with_SOPs_and_CRQs.md` isn't in `git-submodule-tools-rs`'s root. I'll check `/data/data/com.termux.nix/files/home/pick-up-nix2/` instead.`CRQ_Standardize_Task_Documentation_with_SOPs_and_CRQs.md` is missing. I'll read `docs/sop_streamline_documentation_workflow.md` to understand the current documentation workflow and decide next steps.I've reviewed the documentation workflow SOP, which details integrating `meta-meme.wiki` into `zola` docs. The task also includes consolidating `prompts/task_*.md.out*` files into their base `prompts/task_*.md` counterparts and deleting the `.out*` files. Since the referenced CRQ is missing, I'll prioritize these two aspects. My plan is to first identify all `prompts/task_*.md.out*` files, then review and consolidate them into their base files, deleting the `.out*` files afterward. The `meta-meme.wiki` integration will follow. I'll begin by locating the `prompts/task_*.md.out*` files.No `prompts/task_*.md.out*` files were found, despite the `git-ignored` note. Reviewing the directory structure, I see `reviewsubmodule_task*.md.out*` and `reviewsubmodule.md.out*` files. I'll adjust the `glob` pattern to `prompts/*.md.out*` to find all `.out` files in `prompts`.Okay, I have the list of `.out*` files. My plan is to identify each `.out*` file's base, read both, consolidate relevant content into the base file (prioritizing `.out*` content for newer information), write the consolidated content, and then delete the `.out*` file. I'll begin by reading `reviewsubmodule_task2.md.out2.md`, `reviewsubmodule_task2.md.out2.md.prompt.md`, and `reviewsu... [truncated]
