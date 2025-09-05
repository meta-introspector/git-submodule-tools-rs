mod path_compression;

use std::fs;
use std::path::{Path, PathBuf};
use toml_edit::DocumentMut;
use serde::Deserialize;
use anyhow::{Result, Context};

use crate::path_compression::{PathCompressorTrait, SimplePathCompressor, CompressedPath};

#[derive(Debug, Deserialize)]
struct Config {
    root_path: String,
}

fn main() -> Result<()> {
    println!("cargo_crate_linker is running!");

    let config_path = PathBuf::from("Linker.toml");
    let config_content = fs::read_to_string(&config_path)
        .with_context(|| format!("Could not read config file from {:?}", config_path))?;
    let config: Config = toml::from_str(&config_content)
        .with_context(|| format!("Could not parse config file {:?}", config_path))?;

    let project_root = PathBuf::from(&config.root_path);
    println!("Scanning for Cargo.toml files in: {:?}", project_root);

    let mut compressor = SimplePathCompressor::new();

    let all_cargo_tomls_compressed_paths = scan_for_cargo_tomls(&project_root, &mut compressor)
        .with_context(|| "Error scanning for Cargo.toml files")?;

    for compressed_path in &all_cargo_tomls_compressed_paths {
        let original_path = compressor.decompress_path(compressed_path);
        match process_cargo_toml(&original_path) {
            Ok((name, version)) => {
                println!("Found crate: {} (version: {}) at {:?}", name, version, original_path);
            }
            Err(e) => {
                eprintln!("Error processing {:?}: {}", original_path, e);
            }
        }
    }

    println!("\n--- Path Compression Summary ---");
    println!("Unique path segments ({:}):", compressor.id_to_string.len());
    for (id, s) in compressor.id_to_string.iter().enumerate() {
        println!("  {}: {}", id, s);
    }

    Ok(())
}

// Modified to accept compressor and return CompressedPath
fn scan_for_cargo_tomls(dir: &Path, compressor: &mut SimplePathCompressor) -> Result<Vec<CompressedPath>> {
    let mut cargo_tomls = Vec::new();
    if !dir.exists() {
        return Err(anyhow::anyhow!("Directory does not exist: {:?}", dir));
    }
    if !dir.is_dir() {
        return Err(anyhow::anyhow!("Path is not a directory: {:?}", dir));
    }

    for entry in fs::read_dir(dir)? {
        let entry = entry?;
        let path = entry.path();
        if path.is_dir() {
            // Avoid recursing into target and .git directories
            if path.file_name().map_or(true, |s| s != "target" && s != ".git") {
                cargo_tomls.extend(scan_for_cargo_tomls(&path, compressor)?);
            }
        } else if path.file_name().map_or(false, |s| s == "Cargo.toml") {
            cargo_tomls.push(compressor.compress_path(&path));
        }
    }
    Ok(cargo_tomls)
}

fn process_cargo_toml(path: &Path) -> Result<(String, String)> {
    let content = fs::read_to_string(path)?;
    let doc = content.parse::<DocumentMut>()?;

    let name = doc["package"]["name"]
        .as_str()
        .map(|s| s.to_string())
        .ok_or_else(|| anyhow::anyhow!("Missing package name in {:?}", path))?;
    let version = doc["package"]["version"]
        .as_str()
        .map(|s| s.to_string())
        .ok_or_else(|| anyhow::anyhow!("Missing package version in {:?}", path))?;

    Ok((name, version))
}
