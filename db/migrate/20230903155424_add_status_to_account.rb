class AddStatusToAccount < ActiveRecord::Migration[7.0]
  def change
    add_column :accounts, :status, :integer, default: 0
  end
end
