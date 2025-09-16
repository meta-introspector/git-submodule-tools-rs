# Task: Implement Sliding Window Processing for LLM Prompts (Iterative)

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

--- Appended Content from task_sliding_window.md.out1.md ---
The script `run_sliding_window_prompts.sh` has been created and made executable.

Running the script as configured (`N=42` iterations per task file, with `M` values cycling through `2, 3, 5, 7, 11, 13, 19`) will involve many calls to `gemini-cli` and will generate a significant amount of output files.

**Expected Output and Behavior:**

1.  **Global Initial Context:** The script will first identify and read the content of the lexicographically first file in `prompts/task_*.md`. This content will be labeled "--- Global Initial Context ---" and included in every prompt.
2.  **Task File Processing:** For each `prompts/task_*.md` file:
    *   It will print messages indicating the start of processing for that file.
    *   **Iterative Prompts:** For each of the `N` iterations:
        *   It will display the current iteration number and the `M` value being used for the sliding window.
        *   It will execute `gemini-cli` with a prompt composed of:
            *   The current task file's content.
            *   The "Global Initial Context".
            *   The "Sliding Window Context (Previous Responses)", which will contain the `M` most recent responses from prior iterations of the *same* task file, each labeled "--- Response \[j] ---".
        *   The output from `gemini-cli` will be saved to a file named `[task_file_path].out[iteration_number].md` (e.g., `prompts/task_example.md.out1.md`, `prompts/task_example.md.out2.md`, etc.).
        *   This output will also be `tee`'d to your console.
    *   Messages will indicate the completion of processing for each task file.
3.  **Final Message:** Upon completion of all task files, a "All task files processed." message will be displayed.

To demonstrate the functionality without a potentially very long execution, I can perform a small test run (e.g., `N=2` iterations per task file, with `M_values=(2)`).

Would you like me to proceed with a small test run to demonstrate the functionality, or do you want me to run the full script as configured?