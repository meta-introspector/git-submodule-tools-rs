# flake.nix
{
  description = "A flake for standalone submodule checkouts";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs = { self, nixpkgs }:
    let
      system = "x86_64-linux"; # Assuming x86_64-linux, can be made configurable
      pkgs = import nixpkgs { inherit system; };
    in
    {
      packages.${system}.submodule-checkout =
        let
          # Placeholder for the submodule's git URL and revision
          # IMPORTANT: Replace these with the actual URL and revision of your submodule.
          submoduleUrl = "https://github.com/example/my-submodule.git";
          submoduleRev = "abcdef1234567890abcdef1234567890abcdef12";
          # Placeholder for the sha256 hash. This will be filled in after the first build attempt.
          # Nix will provide the correct hash in the error message.
          submoduleSha256 = "sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=";
        in
        pkgs.stdenv.mkDerivation {
          pname = "standalone-submodule-checkout";
          version = "0.1.0";

          src = pkgs.fetchgit {
            url = submoduleUrl;
            rev = submoduleRev;
            sha256 = submoduleSha256;
          };

          # The build phase is intentionally empty as we only want to fetch the source.
          # The fetched source will be available in $src.
          buildPhase = "";

          # The install phase copies the fetched source to the output directory.
          installPhase = ''
            mkdir -p $out
            cp -r $src/* $out/
          '';
        };
    };
}