use serde::Deserialize;
use anyhow::{Result, Context};
use config::{ConfigError, File, Environment};
use std::path::PathBuf;

#[derive(Debug, Deserialize, Clone)]
pub struct ErrorSuppression {
    pub skip_malformed_toml: bool,
    pub skip_non_existent_files: bool,
    // Add more error types here as needed
}

#[derive(Debug, Deserialize, Clone)]
pub struct Config {
    pub error_suppression: ErrorSuppression,
    pub log_file: Option<PathBuf>,
}

impl Config {
    pub fn new() -> Result<Self, ConfigError> {
        let s = config::Config::builder()
            // Add in `./crate_indexer_config.toml`
            .add_source(File::with_name("crate_indexer_config.toml").required(false))
            // Add in settings from the environment (with a prefix of APP)
            // E.g. `APP_DEBUG=1 ./target/app` would set the `debug` key
            .add_source(Environment::with_prefix("CRATE_INDEXER").separator("_"))
            .build()?;

        s.try_deserialize()
    }
}
