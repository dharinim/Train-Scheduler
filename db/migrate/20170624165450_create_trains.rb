class CreateTrains < ActiveRecord::Migration[5.1]
  def change
    create_table :trains do |t|
      t.string :from_location
      t.string :to_location
      t.integer :seats
      t.timestamps
    end
  end
end
