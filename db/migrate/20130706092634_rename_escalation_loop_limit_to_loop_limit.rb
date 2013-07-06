class RenameEscalationLoopLimitToLoopLimit < ActiveRecord::Migration
  def change
    rename_column :policies, :escalation_loop_limit, :loop_limit
  end
end
