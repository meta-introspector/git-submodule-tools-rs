use std::path::{Path, PathBuf};
use std::collections::HashMap;

pub trait PathCompressorTrait {
    fn compress_path(&mut self, path: &Path) -> CompressedPath;
    fn decompress_path(&self, compressed_path: &CompressedPath) -> PathBuf;
}

#[derive(Debug, Clone)]
pub struct CompressedPath {
    pub segments: Vec<usize>,
}

#[derive(Debug)]
pub struct SimplePathCompressor {
    pub string_to_id: HashMap<String, usize>,
    pub id_to_string: Vec<String>,
}

impl SimplePathCompressor {
    pub fn new() -> Self {
        SimplePathCompressor {
            string_to_id: HashMap::new(),
            id_to_string: Vec::new(),
        }
    }

    fn get_or_insert_id(&mut self, segment: &str) -> usize {
        if let Some(&id) = self.string_to_id.get(segment) {
            id
        } else {
            let id = self.id_to_string.len();
            self.string_to_id.insert(segment.to_string(), id);
            self.id_to_string.push(segment.to_string());
            id
        }
    }
}

impl PathCompressorTrait for SimplePathCompressor {
    fn compress_path(&mut self, path: &Path) -> CompressedPath {
        let segments = path
            .iter()
            .filter_map(|s| s.to_str())
            .map(|s| self.get_or_insert_id(s))
            .collect();
        CompressedPath { segments }
    }

    fn decompress_path(&self, compressed_path: &CompressedPath) -> PathBuf {
        let mut path_buf = PathBuf::new();
        for &id in &compressed_path.segments {
            if let Some(segment) = self.id_to_string.get(id) {
                path_buf.push(segment);
            } else {
                // Handle error or unknown segment, for now just push a placeholder
                path_buf.push("UNKNOWN");
            }
        }
        path_buf
    }
}
