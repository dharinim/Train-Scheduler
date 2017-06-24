class CreateTrainSchedules < ActiveRecord::Migration[5.1]
  def change
    create_table :train_schedules do |t|
      t.references :schedule, :null => false
      t.references :train, :null => false
      t.timestamps
    end
  end
end
