class CreateSchedules < ActiveRecord::Migration[5.1]
  def change
    create_table :schedules do |t|
      t.integer :day_of_the_week
      t.time :departure_time
      t.string :frequency
      t.timestamps
    end
  end
end
