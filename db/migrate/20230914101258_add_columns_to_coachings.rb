class AddColumnsToCoachings < ActiveRecord::Migration[7.0]
  def change
    add_column :coachings, :coaching_title, :string
    add_column :coachings, :manager, :string
    add_column :coachings, :coach, :string
    add_column :coachings, :review_frequency, :string
    add_column :coachings, :review_instance, :string
    add_column :coachings, :kpi, :string
  end
end
