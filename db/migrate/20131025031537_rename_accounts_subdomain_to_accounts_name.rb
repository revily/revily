class RenameAccountsSubdomainToAccountsName < ActiveRecord::Migration
  def change
    rename_column :accounts, :subdomain, :name
  end
end
