class CreateHooks < ActiveRecord::Migration
  def change
    create_table :hooks do |t|
      t.string :name
      t.string :uuid, null: false
      t.text :config, default: {}.to_json
      t.text :events, default: [].to_json
      t.boolean :active, default: false
      t.references :account
      
      t.timestamps
    end
  end
end
