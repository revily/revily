class RenameEventsDataToEventsChangeset < ActiveRecord::Migration
  def change
    rename_column :events, :data, :changeset
  end
end
