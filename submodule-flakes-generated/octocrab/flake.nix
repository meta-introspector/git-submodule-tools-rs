{
  description = "Nix flake for octocrab";

  inputs = {
    nixpkgs.url = "github:meta-introspector/nixpkgs?ref=feature/CRQ-016-nixify";
  };

  outputs = { self, nixpkgs }:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs {
        inherit system;
      };
      submoduleUrl = "https://github.com/XAMPPRocky/octocrab";
      submoduleRev = "1ca87c2b0a0bfcf4fd5f7fd14f29f65883b225f0";
      submoduleSha256 = "0k1ca2bfnaciwg00z0hqqhg4856bz8yzyq9qy0s8v6sxqf4n55zf";
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