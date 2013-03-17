class CreateEvents < ActiveRecord::Migration
  def change
    create_table :events do |t|
      t.text   :message
      t.text   :details
      t.string :state
      t.string :uuid, :null => false, :default => ""

      t.references :service

      t.timestamps
    end
    add_index :events, :uuid, :unique => true
  end
end
