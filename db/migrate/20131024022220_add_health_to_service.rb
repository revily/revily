class AddHealthToService < ActiveRecord::Migration
  def change
    add_column :services, :health, :string, default: "ok"
  end
end
