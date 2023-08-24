class CreateCoachings < ActiveRecord::Migration[7.0]
  def change
    create_table :coachings do |t|
      t.date :coaching_start_date
      t.date :coaching_end_date
      t.boolean :acknowledgement, default: false
      t.datetime :date_acknowledged
      t.references :user, null: false, foreign_key: true
      t.references :account, null: false, foreign_key: true

      t.timestamps
    end
  end
end
