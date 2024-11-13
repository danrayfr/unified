class AddCustomizeFieldInCoachingTemplates < ActiveRecord::Migration[7.0]
  def change
    add_column :coaching_templates, :customs, :jsonb
  end
end
