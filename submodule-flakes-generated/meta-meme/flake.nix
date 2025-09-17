{
  description = "Nix flake for meta-meme";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs = { self, nixpkgs }:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs {
        inherit system;
      };
      submoduleUrl = "https://github.com/meta-introspector/meta-meme";
      submoduleRev = "a9ab89ff3cf5847d54135d28cf03e4ebf789a6e0";
      submoduleSha256 = "1yyx1wbsp2b1ssgs9bqvwd7qbxblazwiqsjxw9y5z9nfv5g6c0pa";
    in {
      packages.${system}.default = pkgs.stdenv.mkDerivation {
        pname = "meta-meme";
        version = "0.1.0";

        src = pkgs.fetchgit {
          url = submoduleUrl;
          rev = submoduleRev;
          sha256 = submoduleSha256;
        };

        buildPhase = "echo 'Submodule meta-meme fetched successfully.'";

        installPhase = "mkdir -p $out/share/meta-meme && cp -r $src/* $out/share/meta-meme";
      };
    };
}