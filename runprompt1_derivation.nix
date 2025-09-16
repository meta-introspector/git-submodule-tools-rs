{ pkgs ? import <nixpkgs> {} }:

pkgs.stdenv.mkDerivation {
  pname = "runprompt1-script";
  version = "0.1.0";

  src = ./.; # Refers to the current directory where the script is located

  installPhase = ''
    mkdir -p $out/bin
    cp runprompt1.sh $out/bin/
  '';

  # Ensure the script is executable
  postInstall = ''
    chmod +x $out/bin/runprompt1.sh
  '';

  # Define dependencies if the script needs any specific tools at runtime
  # For now, assuming bash and nix are available in the environment
  buildInputs = [ pkgs.bash ];
}