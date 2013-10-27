class RemoveNotificationRules < ActiveRecord::Migration
  def up
    remove_index :notification_rules, [ :account_id ]
    remove_index :notification_rules, [ :contact_id ]
    drop_table :notification_rules
  end

  def down
    create_table :notification_rules do |t|
      t.integer    :start_delay, default: 0
      t.string     :uuid
      t.references :contact
      t.references :account
      t.timestamps
    end

    add_index :notification_rules, :contact_id
    add_index :notification_rules, :account_id

  end
end