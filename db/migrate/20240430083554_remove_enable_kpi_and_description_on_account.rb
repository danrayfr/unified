class RemoveEnableKpiAndDescriptionOnAccount < ActiveRecord::Migration[7.1]
  def change
    remove_column :accounts, :enable_kpi
    remove_column :accounts, :description
  end
end
