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

	nix run nixpkgs/26833ad1dad83826ef7cc52e0009ca9b7097c79f#gemini-cli \	
	--include-directories=~/pick-up-nix2/ \
	--model gemini-2.5-flash \
	--checkpointing \
	--prompt `cat prompt.md` \

We want to write a prompt for it based on its state.
