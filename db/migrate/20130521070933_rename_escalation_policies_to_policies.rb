class RenameEscalationPoliciesToPolicies < ActiveRecord::Migration
  def up
    remove_index :escalation_policies, name: 'index_escalation_policies_on_account_id'
    remove_index :service_escalation_policies, name: 'index_service_escalation_policies_on_escalation_policy_id'
    remove_index :service_escalation_policies, name: 'index_service_escalation_policies_on_service_id'
    remove_index :escalation_rules, name: 'index_escalation_rules_on_assignable_id'
    remove_index :escalation_rules, name: 'index_escalation_rules_on_escalation_policy_id'
    rename_table :escalation_policies, :policies
    rename_table :service_escalation_policies, :service_policies
    rename_table :escalation_rules, :policy_rules
    rename_column :service_policies, :escalation_policy_id, :policy_id
    rename_column :policy_rules, :escalation_policy_id, :policy_id
    rename_column :incidents, :current_escalation_rule_id, :current_policy_rule_id
    add_index :policies, [:account_id]
    add_index :service_policies, [:service_id]
    add_index :service_policies, [:policy_id]
    add_index :policy_rules, [:assignable_id]
    add_index :policy_rules, [:policy_id]
  end

  def down
    remove_index :policies, name: 'index_policies_on_account_id'
    remove_index :service_policies, name: 'index_service_policies_on_policy_id'
    remove_index :service_policies, name: 'index_service_policies_on_service_id'
    remove_index :policy_rules, name: 'index_policy_rules_on_assignable_id'
    remove_index :policy_rules, name: 'index_policy_rules_on_policy_id'
    rename_table :policies, :escalation_policies
    rename_table :service_policies, :service_escalation_policies
    rename_table :policy_rules, :escalation_rules
    rename_column :service_escalation_policies, :policy_id, :escalation_policy_id
    rename_column :escalation_rules, :policy_id, :escalation_policy_id
    rename_column :incidents, :current_policy_rule_id, :current_escalation_rule_id
    add_index :escalation_policies, [:account_id]
    add_index :service_escalation_policies, [:service_id]
    add_index :service_escalation_policies, [:escalation_policy_id]
    add_index :escalation_rules, [:assignable_id]
    add_index :escalation_rules, [:escalation_policy_id]
  end
end
