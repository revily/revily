class CreateEscalationPolicies < ActiveRecord::Migration
  def change
    create_table :escalation_policies do |t|
      t.string :name
      t.string :uuid, :null => false
      t.integer :escalation_loop_limit

      t.references :account

      t.timestamps
    end
    add_index :escalation_policies, :account_id
  end
end
