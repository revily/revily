class ChangeUsersAccountIdIndex < ActiveRecord::Migration
  def up
    remove_index :users, name: :index_users_on_account_id
    add_index :users, [ :account_id ]
  end

  def down
    remove_index :users, name: :index_users_on_account_id
    add_index :users, [ :account_id ], unique: true
  end
end
