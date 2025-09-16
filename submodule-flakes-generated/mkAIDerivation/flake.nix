{
  description = "Nix flake for mkAIDerivation";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs = { self, nixpkgs }:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs {
        inherit system;
      };
      submoduleUrl = "https://github.com/meta-introspector/mkAIDerivation.git";
      submoduleRev = "";
      submoduleSha256 = "sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=";
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