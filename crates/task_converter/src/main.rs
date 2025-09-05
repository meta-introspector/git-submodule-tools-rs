use std::collections::HashMap;
use std::fs;
use std::path::PathBuf;

use walkdir::WalkDir;
use regex::Regex;
use serde::{Serialize, Deserialize};

#[derive(Serialize, Deserialize, Debug)]
struct Task {
    id: String,
    category: String,
    objective: String,
    description: String,
    scope: String,
    acceptance_criteria: String,
    dependencies: String,
    assigned_agent: String,
    status: String,
    notes: String,
    #[serde(rename = "parent_crq")]
    parent_crq: Option<String>,
    #[serde(rename = "injected_context_cacheline")]
    injected_context_cacheline: String,
}

fn generate_injected_context_cacheline() -> String {
    let zos_emojis: Vec<&str> = vec![
        "⬛", "⚪", "✌️", " ত্রি", "🖐️", "⚹", "🧮", "🍀", "⚡", "🌌", "🧬"
    ];
    let separators: Vec<&str> = vec!["\u{200B}", "\u{2060}"]; // Zero Width Space, Word Joiner

    let mut pattern = String::new();
    for (i, &emoji) in zos_emojis.iter().enumerate() {
        pattern.push_str(emoji);
        if i < zos_emojis.len() - 1 {
            pattern.push_str(separators[i % separators.len()]);
        }
    }

    let mut compressed_context = String::new();
    for _ in 0..20 { // Repeat 20 times for a substantial length
        compressed_context.push_str(&pattern);
    }

    compressed_context.push_str("📦✨💾");
    compressed_context
}

fn parse_markdown_task(content: &str) -> HashMap<String, String> {
    let mut data = HashMap::new();
    let re = Regex::new(r"\*\s*\*\*(?P<key>[^:]+):\*\*\s*(?P<value>[^\n]+)").unwrap();
    let mut current_key = String::new();
    let mut current_value = String::new();

    for line in content.lines() {
        if let Some(captures) = re.captures(line) {
            if !current_key.is_empty() {
                data.insert(current_key.trim().to_lowercase().replace(" ", "_"), current_value.trim().to_string());
            }
            current_key = captures["key"].to_string();
            current_value = captures["value"].to_string();
        } else if line.starts_with("*   ") || line.starts_with("    ") || line.starts_with("\t") || line.trim().is_empty() {
            // Continue multi-line value
            if !current_key.is_empty() {
                current_value.push_str("\n");
                current_value.push_str(line.trim());
            }
        } else {
            // This handles the case where the description or acceptance criteria might span multiple lines
            // without being prefixed by a bullet point or indentation.
            if !current_key.is_empty() {
                current_value.push_str("\n");
                current_value.push_str(line.trim());
            }
        }
    }
    if !current_key.is_empty() {
        data.insert(current_key.trim().to_lowercase().replace(" ", "_"), current_value.trim().to_string());
    }
    data
}

fn main() -> Result<(), Box<dyn std::error::Error>> {
    let tasks_dir = PathBuf::from("/data/data/com.termux/files/home/storage/github/git-submodule-tools/tasks");
    let injected_context = generate_injected_context_cacheline();

    for entry in WalkDir::new(&tasks_dir).into_iter().filter_map(|e| e.ok()) {
        let path = entry.path();
        if path.is_file() && path.extension().map_or(false, |ext| ext == "md") {
            println!("Processing file: {:?}", path);
            let content = fs::read_to_string(path)?;
            let mut parsed_data = parse_markdown_task(&content);

            let task_id = parsed_data.get("task_id").cloned().unwrap_or_else(|| {
                path.file_stem().unwrap().to_str().unwrap().to_string()
            });

            let task = Task {
                id: task_id,
                category: parsed_data.remove("category").unwrap_or_default(),
                objective: parsed_data.remove("objective").unwrap_or_default(),
                description: parsed_data.remove("description").unwrap_or_default(),
                scope: parsed_data.remove("scope").unwrap_or_default(),
                acceptance_criteria: parsed_data.remove("acceptance_criteria").unwrap_or_default(),
                dependencies: parsed_data.remove("dependencies").unwrap_or_default(),
                assigned_agent: parsed_data.remove("assigned_agent").unwrap_or_default(),
                status: parsed_data.remove("status").unwrap_or_default(),
                notes: parsed_data.remove("notes").unwrap_or_default(),
                parent_crq: parsed_data.remove("parent_crq"),
                injected_context_cacheline: injected_context.clone(),
            };

            let toml_string = toml::to_string_pretty(&task)?;
            let new_file_path = path.with_extension("toml");
            fs::write(&new_file_path, toml_string)?;
            println!("Converted to: {:?}", new_file_path);

            // Optionally, remove the old .md file
            // fs::remove_file(path)?;
            // println!("Removed old file: {:?}", path);
        }
    }

    Ok(())
}