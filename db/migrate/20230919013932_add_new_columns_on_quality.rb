class AddNewColumnsOnQuality < ActiveRecord::Migration[7.0]
  def change
    add_column :qualities, :link, :string
    add_column :qualities, :metrics, :jsonb
  end
end