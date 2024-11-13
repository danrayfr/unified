class RemoveAssigneeColumnInTicket < ActiveRecord::Migration[7.0]
  def change
    remove_column :tickets, :assignee
  end
end
