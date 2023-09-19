class AddAgentCountInCoachings < ActiveRecord::Migration[7.0]
  def change
    add_column :coachings, :agent_count_per_week, :integer
  end
end
