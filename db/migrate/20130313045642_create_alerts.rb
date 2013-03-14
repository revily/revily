class CreateAlerts < ActiveRecord::Migration
  def change
    create_table :alerts do |t|
      t.string     :type
      t.datetime   :sent_at
      t.string     :uuid, :null => false, :default => ""

      t.references :event

      t.timestamps
    end
    add_index :alerts, :event_id
    add_index :alerts, :uuid, :unique => true
  end
end
