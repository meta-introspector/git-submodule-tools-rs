use std::io::{self, BufRead};
use url::Url;

#[derive(Debug, PartialEq, Eq, PartialOrd, Ord, Clone)]
enum Topic {
    AiMl,
    BlockchainWeb3,
    CompilersFormalMethods,
    Emacs,
    Fonts,
    Gaming,
    GeminiCli,
    GeneralTech,
    Infrastructure,
    KnowledgeManagement,
    MetaIntrospectorProjects,
    Misc,
    MobileDevelopment,
    RustEcosystem,
    SearchEngine,
    SecurityCrypto,
    StaticAnalysis,
    SystemInit,
    Telemetry,
    Testing,
    Tooling,
    Virtualization,
    WebDevelopment,
    VideoDownloader,
    Bootstrapping,
    Mcp,
    RDFa,
    MemoryAllocator,
    RustCompiler,
    GeminiLogs,
    Aipack,
    Aichat,
    Solfunmeme,
    Editor,
    MiniZinc,
}

#[derive(Debug, PartialEq, Eq, PartialOrd, Ord)]
struct RepoInfo {
    topic: Topic,
    org: String,
    name: String,
    url: String,
}

fn categorize_topic(org: &str, name: &str) -> Topic {
    match org {
        "rust-lang" | "rust-embedded" => Topic::RustEcosystem,
        "meta-introspector" => Topic::MetaIntrospectorProjects,
        "llvm" | "leanprover" | "leanprover-community" => Topic::CompilersFormalMethods,
        "apache" => Topic::GeneralTech,
        "dfinity" => Topic::BlockchainWeb3,
        "coreos" => Topic::Infrastructure,
        "openai" | "anthropics" | "mozilla-ocho" => Topic::AiMl,
        "termux" => Topic::MobileDevelopment,
        "gimli-rs" => Topic::Tooling,
        "facebook" => Topic::GeneralTech,
        "googleforgames" => Topic::Gaming,
        "elizaos" => Topic::Infrastructure,
        "qfall" => Topic::SecurityCrypto,
        "salsa.debian.org" => Topic::Bootstrapping, // Reproducible Builds often tied to bootstrapping
        "HoTT" | "UniMath" => Topic::CompilersFormalMethods, // Homotopy Type Theory
        "torvalds" => Topic::Infrastructure,        // Linux Kernel
        "gcc-mirror" => Topic::CompilersFormalMethods, // GCC
        "bminor" => Topic::Tooling,                 // Binutils/GDB
        "systemd" => Topic::SystemInit,
        "qemu" => Topic::Virtualization,
        "astral-sh" => Topic::Tooling, // Python Tooling
        "open-telemetry" => Topic::Telemetry,
        "maximegmd" | "Souldiv" | "MeticulousHome" | "MyJetTools" | "jaedson-barbosa"
        | "carlos-menezes" | "eeeeeta" | "goto-eof" | "thmshmm" | "0x20F" | "JimitSoni18" => {
            Topic::Telemetry
        }
        "goldpuppy" => Topic::WebDevelopment,
        "coccinelle" => Topic::StaticAnalysis,
        "a-ghorbani" => Topic::Misc,
        "musistudio" => Topic::Misc,
        "agentgateway" => Topic::Misc,
        "amazon-q-developer-cli" => Topic::Tooling,
        "asimov.rs" => Topic::AiMl,
        "async-llm" => Topic::AiMl,
        "autogpt" => Topic::AiMl,
        "aibook" => Topic::AiMl,
        "pluely" => Topic::Misc,
        "llm" => Topic::AiMl,
        "geminate" => Topic::Misc,
        "t3router" => Topic::WebDevelopment,
        "google-ai-rs" => Topic::AiMl,
        "zeus-ai-api-gateway" => Topic::WebDevelopment,
        "gemini-ai-rust" => Topic::AiMl,
        "Rust_HTMX_Gemini_AI" => Topic::WebDevelopment,
        "figlet-fonts" | "FIGfonts" | "nerd-fonts" => Topic::Fonts,
        "qwen-code" => Topic::AiMl,
        "chatgpt-shell" => Topic::AiMl,
        "khoj" => Topic::KnowledgeManagement,
        "gemini-repl" => Topic::GeminiCli,
        "gemini-repl-005" => Topic::GeminiCli,
        "efency" => Topic::Misc,
        "jemalloc" => Topic::MemoryAllocator,
        "solfunmeme-dioxus" => Topic::Solfunmeme,
        "straight.el" => Topic::Emacs,
        "zed" => Topic::Editor,
        "bootstrap" => Topic::Bootstrapping,
        "cargo" => Topic::RustEcosystem,
        "trackdown" => Topic::Misc,
        "copper" => Topic::Misc,
        "cargotesting" => Topic::Testing,
        "libminizinc" => Topic::MiniZinc,
        "meilisearch" => Topic::SearchEngine,
        "tinysearch" => Topic::SearchEngine,
        "youtube-dl" => Topic::VideoDownloader,
        "cargo-to-mcp" => Topic::Mcp,
        "mcp" => Topic::Mcp,
        "Escaped-RDFa" => Topic::RDFa,
        "gemm" => Topic::AiMl,
        "ug" => Topic::Misc,
        "safetensors" => Topic::AiMl,
        "rustc" => Topic::RustCompiler,
        "gemini_logs" => Topic::GeminiLogs,
        "aipack" => Topic::Aipack,
        "aichat" => Topic::Aichat,
        _ => {
            // Special handling for Emacs-related repos
            if name.contains("emacs") || name.contains("el") {
                return Topic::Emacs;
            }
            // Special handling for Gemini CLI related repos
            if name.contains("gemini-cli") || name.contains("gemini-repl") {
                return Topic::GeminiCli;
            }
            Topic::Misc
        }
    }
}

fn main() -> io::Result<()> {
    let stdin = io::stdin();
    let mut repos: Vec<RepoInfo> = Vec::new();

    for line in stdin.lock().lines() {
        let line = line?;
        let trimmed_line = line.trim();
        if trimmed_line.is_empty() {
            continue;
        }

        // Attempt to parse as URL
        if let Ok(url) = Url::parse(trimmed_line) {
            let path_segments: Vec<&str> = url.path_segments().map_or(vec![], |s| s.collect());

            if path_segments.len() >= 2 {
                let org = path_segments[path_segments.len() - 2].to_string();
                let mut name = path_segments[path_segments.len() - 1].to_string();

                // Remove .git suffix if present
                if name.ends_with(".git") {
                    name.truncate(name.len() - ".git".len());
                }

                let topic = categorize_topic(&org, &name);

                repos.push(RepoInfo {
                    topic,
                    org,
                    name,
                    url: trimmed_line.to_string(),
                });
            } else {
                eprintln!(
                    "Warning: Could not parse organization/name from URL: {}",
                    trimmed_line
                );
            }
        } else {
            eprintln!("Warning: Could not parse line as URL: {}", trimmed_line);
        }
    }

    repos.sort();

    let mut current_topic: Option<Topic> = None;
    let mut current_org: Option<String> = None;

    for repo in repos {
        if current_topic.is_none() || current_topic.as_ref().unwrap() != &repo.topic {
            println!("# Topic: {:?}", repo.topic);
            current_topic = Some(repo.topic.clone());
            current_org = None; // Reset org when topic changes
        }

        if current_org.is_none() || current_org.as_ref().unwrap() != &repo.org {
            println!("## Organization: {}", repo.org);
            current_org = Some(repo.org.clone());
        }

        println!("[submodule \"vendor/{}/{}\"]", repo.org, repo.name);
        println!("\tpath = vendor/{}/{}", repo.org, repo.name);
        println!("\turl = {}", repo.url);
    }

    Ok(())
}
