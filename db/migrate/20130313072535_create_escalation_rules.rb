class CreateEscalationRules < ActiveRecord::Migration
  def change
    create_table :escalation_rules do |t|
      t.integer :escalation_timeout, default: 30
      t.string :uuid

      t.references :assignable, polymorphic: true
      t.references :escalation_policy

      t.timestamps
    end
    add_index :escalation_rules, :assignable_id
    add_index :escalation_rules, :escalation_policy_id
  end
end
