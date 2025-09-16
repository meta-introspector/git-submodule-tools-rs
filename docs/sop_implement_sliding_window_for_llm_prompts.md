# Standard Operating Procedure: Implement Sliding Window Processing for LLM Prompts

## Objective:
Modify the existing script to iteratively process task files, incorporating a "sliding window" mechanism for context management. This will allow the LLM to maintain a coherent understanding of ongoing tasks by referencing a defined number of previous responses.

## Current Script (Example):

```bash
for x in prompts/reviewsubmodule*.md;
do echo "${x}";
   cat prompt.md | nix run nixpkgs/26833ad1dad83826ef7cc52e0009ca9b7097c79f#gemini-cli -- --include-directories=~/pick-up-nix2/ --model gemini-2.5-flash --y --checkpointing --prompt | tee "${x}.out";
done
```

## Desired Modification:

The script should be enhanced to:

1.  **Iterate through Task Files:** Process each task file (e.g., `prompts/reviewsubmodule*.md`) sequentially.
2.  **Maintain Task State:** The script should be aware of the current state of the task, potentially derived from the content of the task files themselves.
3.  **Sliding Window Context:** For each iteration, the LLM prompt should include:
    *   The content of the current task file.
    *   A "sliding window" of the `N` most recent responses from previous iterations.
4.  **Preserve Initial Context:** Always include the content of the very first task file in the prompt, in addition to the sliding window. This ensures the foundational context is never lost.
5.  **Output Management:** Capture the LLM's response for each iteration, potentially appending it to a log or a new output file, which then becomes part of the "sliding window" for subsequent iterations.

## Parameters:

*   `N`: The number of previous responses to include in the sliding window. (To be defined during implementation).

## Acceptance Criteria:

*   A modified script that implements the sliding window logic.
*   Demonstrable execution showing the LLM receiving and utilizing the sliding window context.
*   Clear output indicating the progression of the task and the LLM's responses.