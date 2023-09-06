class CreateQaTemplates < ActiveRecord::Migration[7.0]
  def change
    create_table :qa_templates do |t|
      t.string :name
      t.boolean :published, default: true
      t.jsonb :metrics, default: [], array: true
      t.references :account, null: false, foreign_key: true

      t.timestamps
    end
  end
end
