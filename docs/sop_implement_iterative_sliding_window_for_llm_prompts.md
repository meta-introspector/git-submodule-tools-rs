# Standard Operating Procedure: Implement Sliding Window Processing for LLM Prompts (Iterative)

## Objective:
Enhance the existing script to iteratively process task files, incorporating a "sliding window" mechanism for context management. This will allow the LLM to maintain a coherent understanding of ongoing tasks by referencing a defined number of previous responses. Each task file will be processed `N` times, with a sliding window of `M` previous responses.

## Current Script (Example):

```bash
for x in prompts/task_*.md;
do echo "${x}";
   if [ ! -f "${x}.out1.md" ]
   then
       cat "${x}" | nix run nixpkgs/26833ad1dad83826ef7cc52e0009ca9b7097c79f#gemini-cli -- --include-directories=~/pick-up-nix2/ --model gemini-2.5-flash --y --checkpointing --prompt | tee "${x}.out1.md";
   fi
done
```

## Desired Modification:

The script should be enhanced to:

1.  **Iterate through Task Files:** Process each task file (e.g., `prompts/task_*.md`) sequentially.
2.  **Iterate Multiple Times per Task File:** For each task file, run the `gemini-cli` `N` times (where `N=42`).
3.  **Maintain Task State:** The script should be aware of the current state of the task, potentially derived from the content of the task files themselves.
4.  **Sliding Window Context:** For each iteration, the LLM prompt should include:
    *   The content of the current task file (`cat "${x}"`).
    *   A "sliding window" of the `M` most recent responses from previous iterations (starting with `M=2`, then expanding to `3, 5, 7, 11, 13, 19` in phases).
5.  **Preserve Initial Context:** Always include the content of the very first task file in the prompt, in addition to the sliding window. This ensures the foundational context is never lost.
6.  **Output Management:** Capture the LLM's response for each iteration, appending it to a new output file (e.g., `${x}.out<iteration_number>.md`). This output then becomes part of the "sliding window" for subsequent iterations.
7.  **Automated Review (Future):** While currently for human review, the "review them" aspect implies future integration with tools like Shellcheck, Nix lint, Rust Clippy, etc.

## Parameters:

*   `N`: Total number of times `gemini-cli` should run for each task file (currently `42`).
*   `M`: Size of the sliding window of previous responses (starting with `2`, expanding to `3, 5, 7, 11, 13, 19`).

## Acceptance Criteria:

*   A modified script that implements the iterative processing with sliding window logic.
*   Demonstrable execution showing the LLM receiving and utilizing the sliding window context.
*   Clear output indicating the progression of the task and the LLM's responses, saved to appropriately named files.