class AddUserToContacts < ActiveRecord::Migration
  def change
    add_column :contacts, :user_id, :integer
    add_index :contacts, [ :user_id ]
    remove_index :contacts, column: :contactable_id, name: :index_contacts_on_contactable_id
    remove_column :contacts, :contactable_id, :integer
    remove_column :contacts, :contactable_type, :string
  end
end
