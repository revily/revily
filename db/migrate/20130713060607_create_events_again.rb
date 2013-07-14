class CreateEventsAgain < ActiveRecord::Migration
  def change
    create_table :events do |t|
      t.references :source, polymorphic: true, index: true
      t.text :data, default: {}.to_json
      t.references :account, index: true
      t.string :event
    end
  end
end
