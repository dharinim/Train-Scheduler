class CreateTrains < ActiveRecord::Migration[5.1]
  def change
    create_table :trains do |t|
      t.integer :from_city_id
      t.integer :to_city_id
      t.integer :seats
      t.timestamps
    end
  end
end
