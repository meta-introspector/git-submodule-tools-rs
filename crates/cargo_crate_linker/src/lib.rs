use std::collections::HashMap;
use std::path::{Path, PathBuf};
use std::cell::RefCell;

// Trait for path compression strategies
pub trait PathCompressorTrait {
    fn compress_path(&mut self, path: &Path) -> CompressedPath;
    fn decompress_path(&self, compressed_path: &CompressedPath) -> PathBuf;
}

// Simple implementation of PathCompressorTrait using HashMap and Vec
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

    fn get_or_insert_id(&mut self, s: &str) -> usize {
        if let Some(&id) = self.string_to_id.get(s) {
            id
        } else {
            let id = self.id_to_string.len();
            self.id_to_string.push(s.to_string());
            self.string_to_id.insert(s.to_string(), id);
            id
        }
    }
}

impl PathCompressorTrait for SimplePathCompressor {
    fn compress_path(&mut self, path: &Path) -> CompressedPath {
        let mut compressed_segments = Vec::new();
        for segment in path.iter() {
            let segment_str = segment.to_string_lossy();
            compressed_segments.push(self.get_or_insert_id(&segment_str));
        }
        CompressedPath::Compressed(compressed_segments, RefCell::new(None))
    }

    fn decompress_path(&self, compressed_path: &CompressedPath) -> PathBuf {
        match compressed_path {
            CompressedPath::Original(p) => p.clone(),
            CompressedPath::Compressed(compressed_segments, cached_path) => {
                if let Some(p) = cached_path.borrow().as_ref() {
                    p.clone()
                } else {
                    let mut path = PathBuf::new();
                    for &id in compressed_segments {
                        if let Some(s) = self.id_to_string.get(id) {
                            path.push(s);
                        }
                    }
                    *cached_path.borrow_mut() = Some(path.clone());
                    path
                }
            }
        }
    }
}

// Enum to represent a path in either original or compressed form
#[derive(Debug, Clone)]
pub enum CompressedPath {
    Original(PathBuf),
    Compressed(Vec<usize>, RefCell<Option<PathBuf>>),
}

impl From<PathBuf> for CompressedPath {
    fn from(path: PathBuf) -> Self {
        CompressedPath::Original(path)
    }
}

impl From<Vec<usize>> for CompressedPath {
    fn from(compressed: Vec<usize>) -> Self {
        // When creating from Vec<usize>, it's assumed to be compressed
        // The decompressed path will be cached on first access via decompress_path
        CompressedPath::Compressed(compressed, RefCell::new(None))
    }
}