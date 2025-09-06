use std::path::PathBuf;
use std::time::SystemTime;

// Represents a user query or challenge.
#[derive(Debug, Clone)]
pub struct Query {
    pub content: String,
    pub timestamp: SystemTime,
}

// Represents a piece of poetic verse generated.
#[derive(Debug, Clone)]
pub struct Verse {
    pub content: String,
    pub author: String,
    pub inspiration_source: String,
}

// Represents the act of observation or analysis.
#[derive(Debug, Clone)]
pub struct Gaze {
    pub target: PathBuf,
    pub timestamp: SystemTime,
    pub focus_area: String,
}

// Represents a missing concept or an area for new development.
#[derive(Debug, Clone)]
pub struct Gap {
    pub description: String,
    pub location: String,
    pub severity: String,
}

// Represents a reflection or mapping between two entities.
#[derive(Debug, Clone)]
pub struct Mirror {
    pub source: String,
    pub reflection: String,
}

// Represents a tool or framework for understanding.
#[derive(Debug, Clone)]
pub struct Lens {
    pub purpose: String,
    pub magnification_level: f64,
}

// Represents an acknowledgment or homage.
#[derive(Debug, Clone)]
pub struct Tribute {
    pub subject: String,
    pub form: String,
}
