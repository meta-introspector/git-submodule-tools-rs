
for x in prompts/task_*.md;
do echo "${x}";
   if [ ! -f "${x}.out1.md" ]
   then
       cat "${x}" | nix run nixpkgs/26833ad1dad83826ef7cc52e0009ca9b7097c79f#gemini-cli -- --include-directories=~/pick-up-nix2/ --model gemini-2.5-flash --y --checkpointing --prompt | tee "${x}.out1.md";
   fi
done
