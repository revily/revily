class RemoveNullConstraintFromPositions < ActiveRecord::Migration
  def up
    change_column :user_schedule_layers, :position, :integer, null: true
  end

  def down
    change_column :user_schedule_layers, :position, :integer, null: false
  end

end
