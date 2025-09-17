#!/usr/bin/env bash

# Define the base name for prompt files relative to the script's execution directory.
PROMPT_BASENAME="prompts/reviewsubmodule"

# Define the absolute path to the main project directory for gemini-cli's --include-directories.
# This is based on the user's provided context for the larger project root.
GEMINI_CLI_PROJECT_ROOT="/data/data/com.termux.nix/files/home/pick-up-nix2"

# Loop 10 times to generate sequential outputs.
for i in $(seq 1 10); do
    echo "--- Processing iteration $i ---"

    # Concatenate all existing prompt files matching the pattern.
    # This ensures that outputs from previous iterations are included as input for the current one.
    # The glob pattern "${PROMPT_BASENAME}"*.md will expand to include files like:
    # prompts/reviewsubmodule.md
    # prompts/reviewsubmodule.out1.md
    # prompts/reviewsubmodule.out2.md (if they exist from previous runs)
    PROMPT_CONTENT=$(cat "${PROMPT_BASENAME}"*.md)

    # Execute the gemini-cli with the concatenated prompt content.
    # The output is displayed on stdout and simultaneously saved to a new file.
    echo "${PROMPT_CONTENT}" | nix run nixpkgs/26833ad1dad83826ef7cc52e0009ca9b7097c79f#gemini-cli \
        -- \
        --include-directories="${GEMINI_CLI_PROJECT_ROOT}/" \
        --model gemini-2.5-flash \
        --y \
        --checkpointing \
        --prompt \
        | tee "${PROMPT_BASENAME}.out${i}.md"

    # Check the exit status of the nix run command (the first command in the pipe).
    if [ ${PIPESTATUS[0]} -ne 0 ]; then
        echo "Error: nix run command failed in iteration $i. Exiting."
        exit 1
    fi
done

echo "All iterations completed successfully."
