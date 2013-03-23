class CreateSchedules < ActiveRecord::Migration
  def change
    create_table :schedules do |t|
      t.string   :name
      t.string   :time_zone, default: 'UTC'
      t.string   :uuid
      t.datetime :start_at

      t.timestamps
    end
  end
end
