class AddMissingIndexes < ActiveRecord::Migration
  def change
    add_index :hooks, :account_id
    
    add_index :incidents, :service_id
    add_index :incidents, :current_policy_rule_id
    add_index :incidents, :key
    add_index :incidents, :message

    add_index :taggings, [ :tagger_id, :tagger_type ]
  end
end
