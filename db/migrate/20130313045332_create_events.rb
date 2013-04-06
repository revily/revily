class CreateEvents < ActiveRecord::Migration
  def change
    create_table :events do |t|
      t.text   :message
      t.text   :description
      t.text   :details
      t.string :state
      t.string :key
      t.integer :current_user_id
      t.integer :current_escalation_rule_id
      t.integer :escalation_loop_count, default: 0
      t.string :uuid, null: false

      t.references :service

      t.datetime :triggered_at
      t.datetime :acknowledged_at
      t.datetime :resolved_at
      
      t.timestamps
    end
    add_index :events, :current_user_id
    add_index :events, :uuid, unique: true
  end
end