use walkdir::WalkDir;
use std::fs;
use std::path::Path;
use regex::Regex;
use std::collections::HashMap;

fn main() -> Result<(), Box<dyn std::error::Error>> {
    let docs_path = Path::new("docs");
    let word_re = Regex::new(r"\b\w+\b")?;

    println!("Reading poem files from {:?}", docs_path);

    let mut all_words: Vec<String> = Vec::new();

    for entry in WalkDir::new(docs_path)
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

    println!("\n--- Glossary (Word Counts) ---");
    let mut sorted_glossary: Vec<(&String, &usize)> = glossary.iter().collect();
    sorted_glossary.sort_by_key(|&(word, _)| word);
    for (word, count) in sorted_glossary {
        println!("{}: {}", word, count);
    }

    // --- N-gram and Graph Generation ---
    let mut graph: HashMap<String, HashMap<String, usize>> = HashMap::new();

    let n_gram_sizes = vec![2, 3, 5, 7];

    for &n in &n_gram_sizes {
        println!("\n--- Generating {}-grams and Graph Edges ---", n);
        for i in 0..all_words.len().saturating_sub(n - 1) {
            let n_gram_vec: Vec<&str> = all_words[i..i + n].iter().map(|s| s.as_str()).collect();
            let n_gram_key = n_gram_vec[0].to_string();
            let n_gram_value = n_gram_vec[1..].join(" ");

            *graph.entry(n_gram_key).or_default().entry(n_gram_value).or_insert(0) += 1;
        }
    }

    println!("\n--- Graph Edges (Sample) ---");
    let mut sorted_graph_sources: Vec<(&String, &HashMap<String, usize>)> = graph.iter().collect();
    sorted_graph_sources.sort_by_key(|&(source, _)| source);

    for (source, targets) in sorted_graph_sources.into_iter().take(10) { // Take first 10 for sample output
        println!("Source: {}", source);
        let mut sorted_targets: Vec<(&String, &usize)> = targets.iter().collect();
        sorted_targets.sort_by_key(|&(target, _)| target);
        for (target, count) in sorted_targets.into_iter().take(5) { // Take first 5 targets for sample
            println!("  -> {}: {}", target, count);
        }
    }

    Ok(())
}
