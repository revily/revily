class RenameAssignableToAssignment < ActiveRecord::Migration
  def up
    remove_index :policy_rules, name: 'index_policy_rules_on_assignable_id'
    rename_column :policy_rules, :assignable_id, :assignment_id
    rename_column :policy_rules, :assignable_type, :assignment_type
    add_index :policy_rules, [ :assignment_id, :assignment_type ]
  end

  def down
    remove_index :policy_rules, name: 'index_policy_rules_on_assignment_id_and_assignment_type'
    rename_column :policy_rules, :assignment_id, :assignable_id
    rename_column :policy_rules, :assignment_type, :assignable_type
    add_index :policy_rules, [ :assignable_id ]
  end
end
