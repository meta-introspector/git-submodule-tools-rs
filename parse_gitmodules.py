import configparser
import os

def parse_gitmodules(file_path):
    config = configparser.ConfigParser()
    config.read(file_path)
    submodules = []
    for section in config.sections():
        if section.startswith('submodule'):
            name = section.split('"')[1]
            path = config[section]['path']
            url = config[section]['url']
            submodules.append({'name': name, 'path': path, 'url': url})
    return submodules

def generate_nix_flake(submodule_name, submodule_url, submodule_path):
    flake_content = f"""{{
  description = "Nix flake for submodule {submodule_name}";

  inputs = {{
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  }};

  outputs = {{ self, nixpkgs }}:
    let
      pkgs = import nixpkgs {{ system = "x86_64-linux"; }};
    in {{
      packages.x86_64-linux.{submodule_name} = pkgs.stdenv.mkDerivation {{
        pname = "{submodule_name}";
        version = "0.1.0"; # Placeholder, can be updated later

        src = pkgs.fetchgit {{
          url = "{submodule_url}";
          rev = "PUT_SUBMODULE_REV_HERE"; # Placeholder for the specific commit hash
          sha256 = "PUT_SUBMODULE_SHA256_HERE"; # Placeholder for the sha256 hash
        }};

        # If the submodule is a Rust project, you might want to use buildRustPackage
        # For now, a generic mkDerivation is used.
        # buildInputs = [ pkgs.rustc pkgs.cargo ];
        # cargoDeps = pkgs.callPackage ./cargo-deps.nix {{ }};

        # buildPhase = ''
        #   cargo build --release
        # '';

        # installPhase = ''
        #   mkdir -p $out/bin
        #   cp target/release/{submodule_name} $out/bin/
        # '';
      }};
    }};
}}
"""
    return flake_content

def main():
    gitmodules_path = "/data/data/com.termux.nix/files/home/pick-up-nix2/source/github/meta-introspector/git-submodule-tools-rs/.gitmodules"
    submodules = parse_gitmodules(gitmodules_path)

    output_dir = "/data/data/com.termux.nix/files/home/pick-up-nix2/submodule-flakes"
    os.makedirs(output_dir, exist_ok=True)

    for submodule in submodules:
        name = submodule['name'].replace('vendor/', '').replace('/', '-') # Sanitize name for directory and package
        path = submodule['path']
        url = submodule['url']

        submodule_flake_dir = os.path.join(output_dir, name)
        os.makedirs(submodule_flake_dir, exist_ok=True)

        flake_content = generate_nix_flake(name, url, path)
        flake_file_path = os.path.join(submodule_flake_dir, "flake.nix")
        with open(flake_file_path, "w") as f:
            f.write(flake_content)
        print(f"Generated flake for {name} at {flake_file_path}")

if __name__ == "__main__":
    main()