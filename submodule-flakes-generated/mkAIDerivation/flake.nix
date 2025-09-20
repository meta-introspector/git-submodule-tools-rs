{
  description = "Nix flake for mkAIDerivation";

  inputs = {
    nixpkgs.url = "github:meta-introspector/nixpkgs?ref=feature/CRQ-016-nixify";
  };

  outputs = { self, nixpkgs }:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs {
        inherit system;
      };
      submoduleUrl = "https://github.com/meta-introspector/mkAIDerivation.git";
      submoduleRev = "d79de32084e11e204bbe671a0005d40041a01223";
      submoduleSha256 = "0y1h0ccf1swy5bap5vc4k14a08cbhbzs9py36jgfqr80425zvz5l";
    in {
      packages.${system}.default = pkgs.stdenv.mkDerivation {
        pname = "mkAIDerivation";
        version = "0.1.0";

        src = pkgs.fetchgit {
          url = submoduleUrl;
          rev = submoduleRev;
          sha256 = submoduleSha256;
        };

        buildPhase = "echo 'Submodule mkAIDerivation fetched successfully.'";

        installPhase = "mkdir -p $out/share/mkAIDerivation && cp -r $src/* $out/share/mkAIDerivation";
      };
    };
}