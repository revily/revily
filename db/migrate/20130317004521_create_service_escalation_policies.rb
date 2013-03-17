class CreateServiceEscalationPolicies < ActiveRecord::Migration
  def change
    create_table :service_escalation_policies do |t|
      t.string :uuid
      
      t.references :service
      t.references :escalation_policy

      t.timestamps
    end
    add_index :service_escalation_policies, :service_id
    add_index :service_escalation_policies, :escalation_policy_id
  end
end
