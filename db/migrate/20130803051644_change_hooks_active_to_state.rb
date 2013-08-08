class ChangeHooksActiveToState < ActiveRecord::Migration
  def change
    add_column :hooks, :state, :string
    remove_column :hooks, :active, :boolean
  end
end
