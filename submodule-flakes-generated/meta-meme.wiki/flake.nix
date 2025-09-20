{
  description = "Nix flake for meta-meme.wiki";

  inputs = {
    nixpkgs.url = "github:meta-introspector/nixpkgs?ref=feature/CRQ-016-nixify";
  };

  outputs = { self, nixpkgs }:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs {
        inherit system;
      };
      submoduleUrl = "https://github.com/meta-introspector/meta-meme.wiki.git";
      submoduleRev = "c5ca5fb4782458ca5d3d550acb8d25733cff6263";
      submoduleSha256 = "02d0sfl2aih22kyys719ix5n8389jgidwji5p31dy4vs4nc49swi";
    in {
      packages.${system}.default = pkgs.stdenv.mkDerivation {
        pname = "meta-meme.wiki";
        version = "0.1.0";

        src = pkgs.fetchgit {
          url = submoduleUrl;
          rev = submoduleRev;
          sha256 = submoduleSha256;
        };

        buildPhase = "echo 'Submodule meta-meme.wiki fetched successfully.'";

        installPhase = "mkdir -p $out/share/meta-meme.wiki && cp -r $src/* $out/share/meta-meme.wiki";
      };
    };
}