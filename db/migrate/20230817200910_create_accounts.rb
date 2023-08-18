class CreateAccounts < ActiveRecord::Migration[7.0]
  def change
    create_table :accounts do |t|
      t.string :name
      t.text :description
      t.string :uid, default: -> { 'gen_random_uuid()' }, null: false

      t.timestamps
    end
  end
end
