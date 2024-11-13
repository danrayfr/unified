class AddModifiedByInTicket < ActiveRecord::Migration[7.0]
  def change
    add_column :tickets, :modified_by, :string
  end
end
