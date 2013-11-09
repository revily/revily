class RemoveEventAndRenameDataFromEvents < ActiveRecord::Migration
  def up
    remove_column :events, :event, :string
    change_column :events, :data, :text, default: {}.to_json
    add_column :events, :uuid, :string, default: "" #, null: false

    # hackety-hack
    say_with_time "Set uuid on all existing events" do
      def Event.readonly_attributes; Set.new; end

      Event.all.each do |event|
        event.send(:ensure_uuid)
        event.save!
      end
    end

    change_column :events, :uuid, :string, null: false

    add_index :events, [ :uuid ], name: 'index_events_on_uuid', unique: true
  end

  def down
    remove_index :events, [ :uuid ]
    remove_column :events, :uuid, :string
    change_column :events, :data, :text, default: {}.to_json
    add_column :events, :event, :string
  end
end
