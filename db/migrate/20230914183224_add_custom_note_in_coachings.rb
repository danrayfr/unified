class AddCustomNoteInCoachings < ActiveRecord::Migration[7.0]
  def change
    add_column :coachings, :custom_note, :jsonb
  end
end
