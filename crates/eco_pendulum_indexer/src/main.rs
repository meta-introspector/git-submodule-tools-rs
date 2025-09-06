use std::fs;
use std::io::{self, BufRead};
use rand::seq::SliceRandom;
use rand::thread_rng;

fn main() -> io::Result<()> {
    println!("Abulafia: Initiating the Grand Game of Connections...");

    let fragments_dir = "./fragments";
    let mut all_lines: Vec<String> = Vec::new();

    match fs::read_dir(fragments_dir) {
        Ok(entries) => {
            for entry in entries {
                let entry = entry?;
                let path = entry.path();

                if path.is_file() {
                    println!("\nProcessing fragment: {}", path.display());
                    let file = fs::File::open(&path)?;
                    let reader = io::BufReader::new(file);

                    for line in reader.lines() {
                        let line = line?;
                        if !line.trim().is_empty() { // Only add non-empty lines
                            all_lines.push(line);
                        }
                    }
                }
            }
        }
        Err(_) => {
            println!("Error: 'fragments' directory not found or accessible. Please create it and add some text files (e.g., .txt, .md) with content for Abulafia to process.");
            println!("Example: mkdir fragments && echo \"The Templars hid a secret.\" > fragments/secret.txt");
            return Ok(())
        }
    }

    if all_lines.is_empty() {
        println!("No lines found in fragments. Abulafia needs text to weave its tales.");
        return Ok(())
    }

    println!("\nAbulafia is weaving 'The Plan'...");

    let mut rng = thread_rng();
    let num_connections = 5; // Number of random connections to generate
    let connection_length = 3; // Number of lines per connection

    for i in 0..num_connections {
        println!("\n--- Connection {} ---", i + 1);
        let mut connection_lines: Vec<String> = Vec::new();
        for _ in 0..connection_length {
            if let Some(line) = all_lines.choose(&mut rng) {
                connection_lines.push(line.clone());
            }
        }
        for line in connection_lines {
            println!("{}", line);
        }
    }

    println!("\nAbulafia: The Plan is revealed. Interpret as you will.");
    Ok(())
}
