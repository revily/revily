class CreateUserScheduleLayers < ActiveRecord::Migration
  def change
    create_table :user_schedule_layers do |t|
      t.string :uuid, null: false
      t.integer :position, null: false
      t.references :schedule_layer
      t.references :user

      t.timestamps
    end
    add_index :user_schedule_layers, :schedule_layer_id
    add_index :user_schedule_layers, :user_id
  end
end
