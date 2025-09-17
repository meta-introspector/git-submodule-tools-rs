{
  description = "Nix flake for gitoxide";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs = { self, nixpkgs }:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs {
        inherit system;
      };
      submoduleUrl = "https://github.com/GitoxideLabs/gitoxide";
      submoduleRev = "fa1026ef79ecd5b77161f1b93089c5f5a7ea0ec6";
      submoduleSha256 = "1ypd7yr3xnka4sigjx6vmms5n6wdgdafmy90dfsr2bxr84ik12qd";
    in {
      packages.${system}.default = pkgs.stdenv.mkDerivation {
        pname = "gitoxide";
        version = "0.1.0";

        src = pkgs.fetchgit {
          url = submoduleUrl;
          rev = submoduleRev;
          sha256 = submoduleSha256;
        };

        buildPhase = "echo 'Submodule gitoxide fetched successfully.'";

        installPhase = "mkdir -p $out/share/gitoxide && cp -r $src/* $out/share/gitoxide";
      };
    };
}