class CreateScheduleLayers < ActiveRecord::Migration
  def change
    create_table :schedule_layers do |t|
      t.integer :shift_length
      t.integer :position
      t.hstore  :shift
      t.string  :uuid
      
      t.references :schedule

      t.datetime :start_at
      t.timestamps
    end
    add_index :schedule_layers, :schedule_id
    add_hstore_index :schedule_layers, :shift
  end
end
