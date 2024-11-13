class AddAccountLimitToUser < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :account_limit, :integer, default: 1
  end
end
