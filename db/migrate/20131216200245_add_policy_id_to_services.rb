class AddPolicyIdToServices < ActiveRecord::Migration
  def up
    add_column :services, :policy_id, :integer
    add_index :services, [ :policy_id ]

    say_with_time "Set policy_id on all existing services" do
      Service.all.each do |service|
        if service.policy
          service.policy_id = service.policy.id
          service.save!
        end
      end
    end

    remove_index :service_policies, [ :service_id ]
    remove_index :service_policies, [ :policy_id ]

    drop_table :service_policies
  end

  def down
    create_table "service_policies" do |t|
      t.string   "uuid",       null: false
      t.integer  "service_id"
      t.integer  "policy_id"
      t.datetime "created_at"
      t.datetime "updated_at"
    end

    add_index :service_policies, [ :policy_id ]
    add_index :service_policies, [ :service_id ]

    say_with_time "Create ServicePolicy for all existing services" do
      Service.all.each do |service|
        if policy = service.policy
          ServicePolicy.create(service: service, policy: policy)
        end
      end
    end

    remove_index :services, [ :policy_id ]
    remove_column :services, :policy_id
  end
end
