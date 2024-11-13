class AddSlugAndUidToQuality < ActiveRecord::Migration[7.1]
  def change
    add_column :qualities, :uid, :string
    add_column :qualities, :slug, :string
    add_index :qualities, :slug, unique: true
  end
end
