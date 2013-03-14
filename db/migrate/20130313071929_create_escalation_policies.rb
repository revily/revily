class CreateEscalationPolicies < ActiveRecord::Migration
  def change
    create_table :escalation_policies do |t|
      t.string :name
      t.string :uuid

      t.timestamps
    end
  end
end
