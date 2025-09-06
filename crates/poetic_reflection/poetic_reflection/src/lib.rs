pub mod models;
pub mod meta_models;

#[cfg(test)]
mod tests {
    use super::models::*;
    use std::path::PathBuf;
    use std::time::SystemTime;

    #[test]
    fn test_model_instantiation() {
        // Instantiate Enums
        let transaction_state_complete = TransactionState::Complete;
        let transaction_state_incomplete = TransactionState::Incomplete;
        let transaction_state_error = TransactionState::Error;

        let acl_permission_read = ACLPermission::Read;
        let acl_permission_write = ACLPermission::Write;
        let acl_permission_admin = ACLPermission::Admin;

        // Instantiate Structs
        let transaction = MonadicTransaction {
            id: "tx_001".to_string(),
            description: "Initial project setup".to_string(),
            state: transaction_state_complete.clone(),
            data_generated: 1024,
        };

        let acl_rule = ACLRule {
            resource_path: PathBuf::from("/src/main.rs"),
            user_or_role: "admin".to_string(),
            permission: acl_permission_write.clone(),
        };

        let quality_system = QualitySystem {
            name: "Code Health Monitor".to_string(),
            metrics: vec!["LOC".to_string(), "Complexity".to_string()],
        };

        let system_state = SystemState {
            quality_score: 0.85,
            integrity_status: "Stable".to_string(),
            last_evaluated: SystemTime::now(),
        };

        let system_g = SystemG {
            id: "proj_alpha".to_string(),
            name: "Alpha Project".to_string(),
            current_state: system_state.clone(),
            acl_rules: vec![acl_rule.clone()],
        };

        let task = Task {
            id: "task_001".to_string(),
            description: "Implement user authentication".to_string(),
            state: transaction_state_incomplete.clone(),
            data_output: 512,
        };

        let crate_lattice = CrateLattice {
            name: "my_app_core".to_string(),
            path: PathBuf::from("/crates/my_app_core"),
            incompleteness_state: transaction_state_incomplete.clone(),
            sub_lattices: vec![], // For simplicity, no sub-lattices in this example
            tasks: vec![task.clone()],
        };

        // Assertions (optional, but good practice to ensure values are as expected)
        assert_eq!(transaction.id, "tx_001");
        assert_eq!(acl_rule.permission, ACLPermission::Write);
        assert_eq!(quality_system.name, "Code Health Monitor");
        assert_eq!(system_g.name, "Alpha Project");
        assert_eq!(task.state, TransactionState::Incomplete);
        assert_eq!(crate_lattice.name, "my_app_core");

        println!("Successfully instantiated all models!");
    }
}
