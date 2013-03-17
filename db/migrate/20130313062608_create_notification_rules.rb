class CreateNotificationRules < ActiveRecord::Migration
  def change
    create_table :notification_rules do |t|
      t.integer    :start_delay, default: 0
      t.string     :uuid

      t.references :contact

      t.timestamps
    end
    # add_index :notification_rules, :user_id
    add_index :notification_rules, :contact_id
  end
end
