{
  description = "Nix flake for meta-meme.wiki";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs = { self, nixpkgs }:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs {
        inherit system;
      };
      submoduleUrl = "https://github.com/meta-introspector/meta-meme.wiki.git";
      submoduleRev = "";
      submoduleSha256 = "sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=";
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