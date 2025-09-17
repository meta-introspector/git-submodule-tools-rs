import configparser
import sys
import os

def parse_gitmodules(gitmodules_path):
    config = configparser.ConfigParser()
    # configparser expects a section header without leading/trailing spaces
    # and doesn't like the [submodule "name"] format directly.
    # We'll preprocess the file to make it compatible.
    with open(gitmodules_path, 'r') as f:
        content = f.read()

    # Replace [submodule "name"] with [submodule:name] for configparser
    # and ensure paths/urls are directly under these sections
    processed_content = []
    current_submodule_name = None
    for line in content.splitlines():
        if line.startswith('[submodule "'):
            current_submodule_name = line.split('"')[1]
            processed_content.append(f'[submodule:{current_submodule_name}]')
        elif line.strip().startswith('path = '):
            processed_content.append(line.strip())
        elif line.strip().startswith('url = '):
            processed_content.append(line.strip())
    
    config.read_string('\n'.join(processed_content))

    submodules_data = []
    for section in config.sections():
        if section.startswith('submodule:'):
            submodule_name = section.split(':', 1)[1]
            path = config.get(section, 'path', fallback='')
            url = config.get(section, 'url', fallback='')
            submodules_data.append((submodule_name, path, url))
    return submodules_data

if __name__ == "__main__":
    gitmodules_file = sys.argv[1]
    
    if not os.path.exists(gitmodules_file):
        sys.stderr.write(f"Error: {gitmodules_file} not found.\n")
        sys.exit(1)

    submodules = parse_gitmodules(gitmodules_file)
    for name, path, url in submodules:
        sys.stdout.write(f"{name},{path},{url}\n")
