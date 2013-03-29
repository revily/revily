class CreateEscalationPolicies < ActiveRecord::Migration
  def change
    create_table :escalation_policies do |t|
      t.string :name
      t.string :uuid, :null => false
      t.integer :escalation_loop_limit
      t.timestamps
    end
  end
end
