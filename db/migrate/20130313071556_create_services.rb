class CreateServices < ActiveRecord::Migration
  def change
    create_table :services do |t|
      t.string  :name
      t.integer :auto_resolve_timeout
      t.integer :acknowledge_timeout
      t.string  :state
      t.string  :uuid
      t.string  :authentication_token

      t.references :escalation_policy

      t.timestamps
    end
    add_index :services, :escalation_policy_id
  end
end
