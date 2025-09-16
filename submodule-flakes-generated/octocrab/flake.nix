{
  description = "Nix flake for octocrab";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs = { self, nixpkgs }:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs {
        inherit system;
      };
      submoduleUrl = "https://github.com/XAMPPRocky/octocrab";
      submoduleRev = "";
      submoduleSha256 = "sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=";
    in {
      packages.${system}.default = pkgs.stdenv.mkDerivation {
        pname = "octocrab";
        version = "0.1.0";

        src = pkgs.fetchgit {
          url = submoduleUrl;
          rev = submoduleRev;
          sha256 = submoduleSha256;
        };

        buildPhase = "echo 'Submodule octocrab fetched successfully.'";

        installPhase = "mkdir -p $out/share/octocrab && cp -r $src/* $out/share/octocrab";
      };
    };
}