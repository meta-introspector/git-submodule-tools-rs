{
  description = "Nix flake for zola";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs = { self, nixpkgs }:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs {
        inherit system;
      };
      submoduleUrl = "https://github.com/getzola/zola.git";
      submoduleRev = "";
      submoduleSha256 = "sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=";
    in {
      packages.${system}.default = pkgs.stdenv.mkDerivation {
        pname = "zola";
        version = "0.1.0";

        src = pkgs.fetchgit {
          url = submoduleUrl;
          rev = submoduleRev;
          sha256 = submoduleSha256;
        };

        buildPhase = "echo 'Submodule zola fetched successfully.'";

        installPhase = "mkdir -p $out/share/zola && cp -r $src/* $out/share/zola";
      };
    };
}