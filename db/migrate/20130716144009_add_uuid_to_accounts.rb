class AddUuidToAccounts < ActiveRecord::Migration
  def change
    add_column :accounts, :uuid, :string, default: "" #, null: false

    # hackety-hack

    say_with_time "Set uuid on all existing accounts" do
      def Account.readonly_attributes; Set.new; end

      Account.all.each do |account|
        account.ensure_uuid
        account.save!
      end
    end

    add_index :accounts, [ :uuid ], name: 'index_accounts_on_uuid', unique: true
  end
end