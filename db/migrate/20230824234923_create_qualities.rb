class CreateQualities < ActiveRecord::Migration[7.0]
  def change
    create_table :qualities do |t|
      t.references :ticket, null: false, foreign_key: true
      t.integer :rating
      t.boolean :acknowledgement, default: false
      t.datetime :date_acknowledged

      t.timestamps
    end
  end
end
