{
  description = "Reproducible Git checkout of gitoxide submodule";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-23.11";
    submoduleCheckout = {
      url = "path:../submodule-checkout"; # Relative path to the submodule-checkout flake
      follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, submoduleCheckout }:
    let
      systems = [ "x86_64-linux" "aarch64-linux" ];
      forAllSystems = nixpkgs.lib.genAttrs systems;
    in
    {
      packages = forAllSystems (system:
        let
          pkgs = import nixpkgs { inherit system; };
          gitoxideCheckout = submoduleCheckout.mkSubmodule {
            submoduleUrl = "https://github.com/GitoxideLabs/gitoxide";
            submoduleRev = "fa1026ef79ecd5b77161f1b93089c5f5a7ea0ec6";
            submoduleSha256 = "sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA="; # Placeholder, will be updated by Nix
          };
        in
        {
          gitoxide = gitoxideCheckout.packages.${system}.standalone-submodule-gitoxide;
        }
      );

      devShells = forAllSystems (system:
        let
          pkgs = import nixpkgs { inherit system; };
          gitoxide = self.packages.${system}.gitoxide;
        in
        pkgs.mkShell {
          name = "gitoxide-dev-shell";
          buildInputs = [
            gitoxide
          ];
          shellHook = ''
            echo "gitoxide checked out at: ${gitoxide}"
            ls -la ${gitoxide}
          '';
        }
      );
    };
}