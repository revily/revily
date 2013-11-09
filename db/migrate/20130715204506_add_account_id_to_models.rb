class AddAccountIdToModels < ActiveRecord::Migration
  def up
    # Add columns first
    add_column :incidents,          :account_id, :integer
    add_column :contacts,           :account_id, :integer
    add_column :notification_rules, :account_id, :integer
    add_column :policy_rules,       :account_id, :integer
    add_column :schedule_layers,    :account_id, :integer

    # Update all existing records to have a default column value
    Incident.update_all(account_id: 0)
    Contact.update_all(account_id: 0)
    PolicyRule.update_all(account_id: 0)
    ScheduleLayer.update_all(account_id: 0)

    # Add the NOT NULL constraint
    change_column :incidents,          :account_id, :integer, null: false
    change_column :contacts,           :account_id, :integer, null: false
    change_column :notification_rules, :account_id, :integer, null: false
    change_column :policy_rules,       :account_id, :integer, null: false
    change_column :schedule_layers,    :account_id, :integer, null: false

    # Add the NOT NULL constraint to all other models that previously had the column
    change_column :events,   :account_id, :integer, null: false
    change_column :hooks,    :account_id, :integer, null: false
    change_column :policies, :account_id, :integer, null: false
    change_column :services, :account_id, :integer, null: false
    change_column :users,    :account_id, :integer, null: false

    # Add an index for our new foreign key
    add_index :incidents,          :account_id
    add_index :contacts,           :account_id
    add_index :notification_rules, :account_id
    add_index :policy_rules,       :account_id
    add_index :schedule_layers,    :account_id
  end

  def down
    # Remove the NOT NULL constraint from each table
    change_column :events,   :account_id, :integer, null: true
    change_column :hooks,    :account_id, :integer, null: true
    change_column :policies, :account_id, :integer, null: true
    change_column :services, :account_id, :integer, null: true
    change_column :users,    :account_id, :integer, null: true

    # Remove previously created indexes
    remove_index :incidents,          [ :account_id ]
    remove_index :contacts,           [ :account_id ]
    remove_index :notification_rules, [ :account_id ]
    remove_index :policy_rules,       [ :account_id ]
    remove_index :schedule_layers,    [ :account_id ]

    # Remove the account_id column from each table
    remove_column :incidents,          :account_id
    remove_column :contacts,           :account_id
    remove_column :notification_rules, :account_id
    remove_column :policy_rules,       :account_id
    remove_column :schedule_layers,    :account_id
  end
end
