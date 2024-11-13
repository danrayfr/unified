class CreateAccounts < ActiveRecord::Migration[7.0]
  def change
    create_table :accounts do |t|
      t.string :name
      t.text :description
      t.string :uid
      t.string :user_uid

      t.timestamps
    end
  end
end
