class CreateServices < ActiveRecord::Migration
  def change
    create_table :services do |t|
      t.string  :name
      t.integer :auto_resolve_timeout
      t.integer :acknowledge_timeout
      t.string  :state
      t.string  :uuid
      t.string  :authentication_token

      t.references :account
      # t.references :escalation_policy

      t.timestamps
    end
    add_index :services, :account_id
  end
end
