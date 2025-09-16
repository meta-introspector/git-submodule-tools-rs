
for x in prompts/reviewsubmodule*.md;
do echo "${x}";
   cat prompt.md | nix run nixpkgs/26833ad1dad83826ef7cc52e0009ca9b7097c79f#gemini-cli -- --include-directories=~/pick-up-nix2/ --model gemini-2.5-flash --y --checkpointing --prompt | tee "${x}.out";   
done
