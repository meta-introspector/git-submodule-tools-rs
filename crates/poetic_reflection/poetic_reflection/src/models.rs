use std::path::PathBuf;
use std::time::SystemTime;

// Represents the state of a transaction or task, reflecting completeness or error.
#[derive(Debug, PartialEq, Eq, Clone)]
pub enum TransactionState {
    Complete,
    Incomplete,
    Error,
}

// Defines granular permissions for Access Control Lists.
#[derive(Debug, PartialEq, Eq, Clone)]
pub enum ACLPermission {
    Read,
    Write,
    Execute,
    Modify,
    Admin,
}

// Represents a single monadic transaction or action taken within the project.
#[derive(Debug, Clone)]
pub struct MonadicTransaction {
    pub id: String,
    pub description: String,
    pub state: TransactionState,
    pub data_generated: usize,
}

// Defines a single rule within a Granular Access Control List.
#[derive(Debug, Clone)]
pub struct ACLRule {
    pub resource_path: PathBuf,
    pub user_or_role: String,
    pub permission: ACLPermission,
}

// Represents the Quality System (Q) that monitors the project's state.
#[derive(Debug, Clone)]
pub struct QualitySystem {
    pub name: String,
    pub metrics: Vec<String>,
}

// Describes the current state (S) of the overall System (G).
#[derive(Debug, Clone)]
pub struct SystemState {
    pub quality_score: f64,
    pub integrity_status: String,
    pub last_evaluated: SystemTime,
}

// Represents the overall project or System (G).
#[derive(Debug, Clone)]
pub struct SystemG {
    pub id: String,
    pub name: String,
    pub current_state: SystemState,
    pub acl_rules: Vec<ACLRule>,
}

// Represents a task within the project, which can be incomplete.
#[derive(Debug, Clone)]
pub struct Task {
    pub id: String,
    pub description: String,
    pub state: TransactionState,
    pub data_output: usize,
}

// Represents a recursive Lattice structure, where each Rust crate is a node.
// It can contain sub-lattices (nested crates/modules) and associated tasks.
#[derive(Debug, Clone)]
pub struct CrateLattice {
    pub name: String,
    pub path: PathBuf,
    pub incompleteness_state: TransactionState, // State of incompleteness for this specific lattice/crate
    pub sub_lattices: Vec<CrateLattice>,
    pub tasks: Vec<Task>,
}
