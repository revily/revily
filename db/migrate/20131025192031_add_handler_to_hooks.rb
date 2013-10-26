class AddHandlerToHooks < ActiveRecord::Migration
  def change
    add_column :hooks, :handler, :string
  end
end
