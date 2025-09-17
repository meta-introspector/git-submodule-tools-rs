
import configparser
import os

gitmodules_content = """[submodule "vendor/cargo_metadata"]
	path = vendor/cargo_metadata
	url = https://github.com/oli-obk/cargo_metadata
[submodule "vendor/gitoxide"]
	path = vendor/gitoxide
	url = https://github.com/GitoxideLabs/gitoxide
[submodule "vendor/octocrab"]
	path = vendor/octocrab
	url = https://github.com/XAMPPRocky/octocrab
[submodule "vendor/meta-introspector/meta-meme"]#
	path = vendor/meta-introspector/meta-meme
	url = https://github.com/meta-introspector/meta-meme
[submodule "vendor/meta-introspector/meta-meme.wiki"]
	path = vendor/meta-introspector/meta-meme.wiki
	url = https://github.com/meta-introspector/meta-meme.wiki.git
[submodule "vendor/zola"]
	path = vendor/zola
	url = https://github.com/getzola/zola.git
[submodule "vendor/meta-introspector/mkAIDerivation"]
	path = vendor/meta-introspector/mkAIDerivation
	url = https://github.com/meta-introspector/mkAIDerivation.git
"""

config = configparser.ConfigParser()
config.read_string(gitmodules_content)

base_dir = "/data/data/com.termux.nix/files/home/pick-up-nix2/source/github/meta-introspector/git-submodule-tools-rs/submodule-flakes"
os.makedirs(base_dir, exist_ok=True)

flake_template = """{{
  description = "Nix flake for {submodule_name}";

  inputs = {{
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-23.11"; # Pin to a stable NixOS version
  }};

  outputs = {{ self, nixpkgs }}:
    let
      system = "x86_64-linux"; # Assuming x86_64-linux, adjust if needed
      pkgs = import nixpkgs {{ inherit system; }};
    in {{
      packages.{system}.{submodule_name} = pkgs.stdenv.mkDerivation {{
        pname = "{submodule_name}";
        version = "0.1.0"; # Placeholder, can be updated later

        src = pkgs.fetchgit {{
          url = "{submodule_url}";
          rev = "{submodule_rev}"; # Placeholder for the commit hash
          sha256 = "{submodule_sha256}"; # Placeholder for the SHA256 hash
        }};

        # Add any build instructions specific to the submodule here
        # For now, we'll just copy the source
        installPhase = ''
          mkdir -p $out
          cp -r $src/* $out/
        '';

        meta = with pkgs.lib; {{
          description = "Git submodule: {submodule_name}";
          homepage = "{submodule_url}";
          license = licenses.unfree; # Adjust license as per submodule's license
          platforms = platforms.linux;
        }};
      }};
    }};
}}
"""

naersk_flake_template = """{{
  description = "Nix flake for {submodule_name} (Rust project)";

  inputs = {{
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-23.11";
    flake-utils.url = "github:numtide/flake-utils";
    naersk.url = "github:nix-community/naersk/master"; # Using master for latest naersk
  }};

  outputs = {{ self, nixpkgs, flake-utils, naersk }}@inputs:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs {{ inherit system; }};
        naersk-lib = pkgs.callPackage naersk {{}};
      in
      {{
        packages.${{system}}.default = naersk-lib.buildPackage {{
          pname = "{submodule_name}";
          version = "0.1.0";

          src = pkgs.fetchgit {{
            url = "{submodule_url}";
            rev = "{submodule_rev}";
            sha256 = "{submodule_sha256}";
          }};

          # Additional build inputs if necessary for the Rust project
          # buildInputs = with pkgs; [ ];

          # cargoBuildFlags = [ ];
          # cargoTestFlags = [ ];

          meta = with pkgs.lib; {{
            description = "Rust Git submodule: {submodule_name}";
            homepage = "{submodule_url}";
            license = licenses.unfree; # Adjust license as per submodule's license
            platforms = platforms.linux;
          }};
        }};
      }}
    );
}}
"""

for section in config.sections():
    if section.startswith('submodule'):
        submodule_path = config[section]['path']
        submodule_url = config[section]['url']
        submodule_name = submodule_path.replace('/', '_').replace('-', '_') # Sanitize for Nix package name

        submodule_dir = os.path.join(base_dir, submodule_name)
        os.makedirs(submodule_dir, exist_ok=True)

        flake_content = flake_template.format(
            submodule_name=submodule_name,
            submodule_url=submodule_url,
            submodule_rev="CHANGEME", # Initial placeholder
            submodule_sha256="CHANGEME" # Initial placeholder
        )

        flake_file_path = os.path.join(submodule_dir, "flake.nix")
        with open(flake_file_path, "w") as f:
            f.write(flake_content)
        print(f"Generated {flake_file_path}")

def is_rust_project(submodule_path):
    # This assumes the script is run from the project root
    # and submodules are checked out in the vendor directory
    cargo_toml_path = os.path.join("vendor", submodule_path, "Cargo.toml")
    return os.path.exists(cargo_toml_path)

for section in config.sections():
    if section.startswith('submodule'):
        submodule_path = config[section]['path']
        submodule_url = config[section]['url']
        submodule_name = submodule_path.replace('/', '_').replace('-', '_') # Sanitize for Nix package name

        submodule_dir = os.path.join(base_dir, submodule_name)
        os.makedirs(submodule_dir, exist_ok=True)

        if is_rust_project(submodule_path):
            print(f"Detected Rust project: {submodule_path}")
            selected_template = naersk_flake_template
        else:
            selected_template = flake_template

        flake_content = selected_template.format(
            submodule_name=submodule_name,
            submodule_url=submodule_url,
            submodule_rev="CHANGEME", # Initial placeholder
            submodule_sha256="CHANGEME" # Initial placeholder
        )

        flake_file_path = os.path.join(submodule_dir, "flake.nix")
        with open(flake_file_path, "w") as f:
            f.write(flake_content)
        print(f"Generated {flake_file_path}")
