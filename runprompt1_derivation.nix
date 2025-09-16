
{ pkgs ? import <nixpkgs> {} }:

pkgs.stdenv.mkDerivation {
  pname = "runprompt1-script-runner";
  version = "0.1.0";

  src = ./.; # This will copy the current directory into the derivation

  buildInputs = [ pkgs.bash ];

  # Ensure the main flake.nix is available for the script
  # We'll create a symlink to it in the build environment
  # This assumes the main flake is at the project root, which is ~/pick-up-nix2
  # and the script expects to cd into it.
  # For now, we'll assume the script is run from the current directory (src)
  # and the FLAKE_ROOT variable in the script is correctly set.

  installPhase = ''
    mkdir -p $out/bin
    cp runprompt1.sh $out/bin/runprompt1.sh
    chmod +x $out/bin/runprompt1.sh
  '';

  # The shell script itself will handle the `nix build` calls
  # We just need to make sure it's executable and available.
  # The script expects to be run from the main project root for `nix build .#...`
  # So, we'll provide instructions to the user to run it from there.
  # For the derivation itself, we'll just install the script.
}
