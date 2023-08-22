class CreateTicketDetails < ActiveRecord::Migration[7.0]
  def change
    create_table :ticket_details do |t|
      t.text :content
      t.integer :access_level
      t.references :ticket, null: false, foreign_key: true

      t.timestamps
    end
  end
end
