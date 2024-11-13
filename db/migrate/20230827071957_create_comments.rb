class CreateComments < ActiveRecord::Migration[7.0]
  def change
    create_table :comments do |t|
      t.boolean :pinned, default: false
      t.belongs_to :ticket, null: false, foreign_key: true
      t.belongs_to :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
