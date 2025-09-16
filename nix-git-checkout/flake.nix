{
  description = "Reproducible Git checkout of gitoxide submodule";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-23.11";
    submoduleCheckout = {
      url = "path:/data/data/com.termux.nix/files/home/pick-up-nix2/source/github/meta-introspector/git-submodule-tools-rs/submodule-checkout";
      follows = "nixpkgs";
    };
  };

    outputs = { self, nixpkgs, submoduleCheckout }:
    let
      systems = [ "x86_64-linux" "aarch64-linux" ];
      forAllSystems = nixpkgs.lib.genAttrs systems;
      # Create a local variable for the submoduleCheckout flake output
      submoduleFlake = submoduleCheckout;
    in
    {
      packages = forAllSystems (system:
        let
          pkgs = import nixpkgs { inherit system; };
          gitoxideCheckout = submoduleFlake.mkSubmodule { # Use the local variable here
            submoduleUrl = "https://github.com/GitoxideLabs/gitoxide";
            submoduleRev = "fa1026ef79ecd5b77161f1b93089c5f5a7ea0ec6";
            submoduleSha256 = "sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA="; # Placeholder, will be updated by Nix
          };
          gitoxidePackage = gitoxideCheckout.packages.${system}.standalone-submodule-gitoxide;
        in
        {
          gitoxide = gitoxidePackage;
          default = gitoxidePackage;
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