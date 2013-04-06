class RenameEventsToIncidents < ActiveRecord::Migration
  def change
    remove_index :events, name: 'index_events_on_current_user_id'
    remove_index :events, name: 'index_events_on_uuid'
    rename_table :events, :incidents
    add_index :incidents, [:current_user_id]
    add_index :incidents, [:uuid], unique: true
  end
end
