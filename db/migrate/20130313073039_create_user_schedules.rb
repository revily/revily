class CreateUserSchedules < ActiveRecord::Migration
  def change
    create_table :user_schedules do |t|
      t.string :uuid

      t.references :schedule
      t.references :user

      t.timestamps
    end
    add_index :user_schedules, :schedule_id
    add_index :user_schedules, :user_id
  end
end
