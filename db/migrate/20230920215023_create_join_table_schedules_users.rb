class CreateJoinTableSchedulesUsers < ActiveRecord::Migration[7.0]
  def change
    create_join_table :schedules, :users do |t|
      t.index [:schedule_id, :user_id]
      t.index [:user_id, :schedule_id]
    end
  end
end
