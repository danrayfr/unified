class AddSiteAndKpiToAccount < ActiveRecord::Migration[7.0]
  def change
    add_column :accounts, :site, :integer
    add_column :accounts, :enable_kpi, :boolean, default: true
  end
end
