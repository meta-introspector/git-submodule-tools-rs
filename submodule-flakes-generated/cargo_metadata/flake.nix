{
  description = "Nix flake for cargo_metadata";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs = { self, nixpkgs }:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs {
        inherit system;
      };
      submoduleUrl = "https://github.com/oli-obk/cargo_metadata";
      submoduleRev = "";
      submoduleSha256 = "sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=";
    in {
      packages.${system}.default = pkgs.stdenv.mkDerivation {
        pname = "cargo_metadata";
        version = "0.1.0";

        src = pkgs.fetchgit {
          url = submoduleUrl;
          rev = submoduleRev;
          sha256 = submoduleSha256;
        };

        buildPhase = "echo 'Submodule cargo_metadata fetched successfully.'";

        installPhase = "mkdir -p $out/share/cargo_metadata && cp -r $src/* $out/share/cargo_metadata";
      };
    };
}