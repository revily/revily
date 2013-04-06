class RenameEventsToIncidents < ActiveRecord::Migration
  def change
    rename_table :events, :incidents
  end
end
