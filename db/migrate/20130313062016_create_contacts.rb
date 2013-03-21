class CreateContacts < ActiveRecord::Migration
  def change
    create_table :contacts do |t|
      t.string :label
      t.string :type
      t.string :address
      t.string :uuid, :null => false

      t.references :user

      t.timestamps
    end
    add_index :contacts, :user_id
  end
end
