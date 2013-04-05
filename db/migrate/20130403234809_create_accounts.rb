class CreateAccounts < ActiveRecord::Migration
  def change
    create_table :accounts do |t|
      t.string :subdomain
      # t.references :owner
      t.timestamps
    end
    # add_index :accounts, :owner_id, unique: true
  end
end
