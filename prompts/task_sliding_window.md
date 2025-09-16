
**Operational Principles:**
1.  **Standard Operating Procedures:** All changes must follow documented SOPs and be preceded by Change Requests (CRQs).
2.  **Documentation:** Document all changes thoroughly.
3.  **Scripting First:** Implement changes via shell scripts initially, then translate to Rust, and formally prove with Lean4 and MiniZinc.
10. **Hero's Journey Meta-Meme:** Apply the "hero's journey" (call, refusal, mentor, inner cave, return) as a meta-meme to each function, submodule, project, and "vibe," recording all steps. This process will be iterated 42 times, feeding output as input to the next phase.

our current script is this 

for x in prompts/reviewsubmodule*.md;
do echo "${x}";
   cat prompt.md | nix run nixpkgs/26833ad1dad83826ef7cc52e0009ca9b7097c79f#gemini-cli -- --include-directories=~/pick-up-nix2/ --model gemini-2.5-flash --y --checkpointing --prompt | tee "${x}.out";   
done

we want to change it to run each task file many times, it should know the state of the task from the files and run the next N steps and review them, we want a window of M previous responses. always keep the first file in content so :

1 first file.
2. sliding window of past N responses.

