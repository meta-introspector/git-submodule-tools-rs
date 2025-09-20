{
  description = "Nix flake for cargo_metadata";

  inputs = {
    nixpkgs.url = "github:meta-introspector/nixpkgs?ref=feature/CRQ-016-nixify";
  };

  outputs = { self, nixpkgs }:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs {
        inherit system;
      };
      submoduleUrl = "https://github.com/oli-obk/cargo_metadata";
      submoduleRev = "f0df5d0d220c0625cfa1a624ae7cc3d3ac25e31f";
      submoduleSha256 = "0llrrbzqy2yj2ihzb648hxybbl3z6idfa8r781dfnc9rwl475ihh";
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