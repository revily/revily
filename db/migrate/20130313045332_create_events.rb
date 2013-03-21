class CreateEvents < ActiveRecord::Migration
  def change
    create_table :events do |t|
      t.text   :message
      t.text   :description
      t.text   :details
      t.string :state
      t.string :key
      t.string :uuid, :null => false

      t.references :service

      t.datetime :acknowledged_at
      t.datetime :resolved_at
      
      t.timestamps
    end
    add_index :events, :uuid, :unique => true
  end
end
