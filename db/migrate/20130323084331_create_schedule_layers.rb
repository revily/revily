class CreateScheduleLayers < ActiveRecord::Migration
  def change
    create_table :schedule_layers do |t|
      t.integer :duration
      t.string  :rule, null: false, default: 'daily'
      t.integer :count, null: false, default: 1
      t.integer :position
      t.string  :uuid

      t.references :schedule

      t.datetime :start_at
      t.timestamps
    end
    add_index :schedule_layers, :schedule_id
  end
end
