class AddLinkToSchedules < ActiveRecord::Migration[7.0]
  def change
    add_column :schedules, :link, :string
  end
end
