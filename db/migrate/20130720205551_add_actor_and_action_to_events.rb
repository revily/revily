class AddActorAndActionToEvents < ActiveRecord::Migration
  def change
    change_table :events do |t|
      t.references :actor, polymorphic: true, index: true
      t.string :action, index: true
      
      t.timestamps
    end
  end
end
