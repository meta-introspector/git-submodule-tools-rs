use anyhow::{Context, Result};
use walkdir::WalkDir;
use std::fs;
use std::io::Write; // Add Write trait for writeln!
use std::path::{Path, PathBuf};
use regex::Regex;
use std::collections::HashMap;
use git2::Repository;
use chrono::Local; // Add chrono for timestamp

fn get_git_info(repo_path: &Path) -> Option<(String, Option<String>)> {
    let repo = Repository::discover(repo_path).ok()?;
    let head = repo.head().ok()?;
    let commit = head.peel_to_commit().ok()?;
    let hash = commit.id().to_string();

    let mut dirty_timestamp = None;
    if repo.statuses(None).ok()?.iter().any(|s| s.status() != git2::Status::empty()) {
        dirty_timestamp = Some(Local::now().format("%Y%m%d%H%M%S").to_string());
    }

    Some((hash, dirty_timestamp))
}

fn main() -> Result<(), Box<dyn std::error::Error>> {
    let root_path = Path::new(".");
    let output_filename = if let Some((hash, dirty_timestamp)) = get_git_info(root_path) {
        let mut filename = format!("poem_analyzer_output_{}", hash);
        if let Some(ts) = dirty_timestamp {
            filename.push_str(&format!("_dirty_{}", ts));
        }
        filename.push_str(".txt");
        filename
    } else {
        "poem_analyzer_output_unknown.txt".to_string()
    };
    let output_path = Path::new(&output_filename);

    let word_re = Regex::new(r"\b\w+\b")?;

    let mut all_words: Vec<String> = Vec::new();

    for entry in WalkDir::new(root_path)
        .into_iter()
        .filter_map(|e| e.ok())
        .filter(|e| e.file_type().is_file() && e.path().extension().map_or(false, |ext| {
            let ext_str = ext.to_str().unwrap_or("");
            ext_str == "md" || ext_str == "rs" || ext_str == "sh" || ext_str == "toml" || ext_str == "txt"
        }))
    {
        let path = entry.path();
        let content = fs::read_to_string(path)?;

        for mat in word_re.find_iter(&content) {
            all_words.push(mat.as_str().to_lowercase());
        }
    }

    // --- Glossary Generation ---
    let mut glossary: HashMap<String, usize> = HashMap::new();
    for word in &all_words {
        *glossary.entry(word.clone()).or_insert(0) += 1;
    }

    let mut log_file = fs::File::create(output_path).context("Failed to create output file")?;

    writeln!(log_file, "Reading poem files from {:?}\n", root_path)?;

    writeln!(log_file, "--- Glossary (Word Counts) ---")?;
    let mut sorted_glossary: Vec<(&String, &usize)> = glossary.iter().collect();
    sorted_glossary.sort_by_key(|&(word, _)| word);
    for (word, count) in sorted_glossary {
        writeln!(log_file, "{}: {}", word, count)?;
    }

    // --- N-gram and Graph Generation ---
    let mut graph: HashMap<String, HashMap<String, usize>> = HashMap::new();

    let n_gram_sizes = vec![2, 3, 5, 7];

    for &n in &n_gram_sizes {
        writeln!(log_file, "\n--- Generating {}-grams and Graph Edges ---", n)?;
        for i in 0..all_words.len().saturating_sub(n - 1) {
            let n_gram_vec: Vec<&str> = all_words[i..i + n].iter().map(|s| s.as_str()).collect();
            let n_gram_key = n_gram_vec[0].to_string();
            let n_gram_value = n_gram_vec[1..].join(" ");

            *graph.entry(n_gram_key).or_default().entry(n_gram_value).or_insert(0) += 1;
        }
    }

    writeln!(log_file, "\n--- Graph Edges (Sample) ---")?;
    let mut sorted_graph_sources: Vec<(&String, &HashMap<String, usize>)> = graph.iter().collect();
    sorted_graph_sources.sort_by_key(|&(source, _)| source);

    for (source, targets) in sorted_graph_sources.into_iter().take(10) { // Take first 10 for sample output
        writeln!(log_file, "Source: {}", source)?;
        let mut sorted_targets: Vec<(&String, &usize)> = targets.iter().collect();
        sorted_targets.sort_by_key(|&(target, _)| target);
        for (target, count) in sorted_targets.into_iter().take(5) { // Take first 5 targets for sample
            writeln!(log_file, "  -> {}: {}", target, count)?;
        }
    }

    Ok(())
}
