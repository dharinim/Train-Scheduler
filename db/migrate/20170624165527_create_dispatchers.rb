class CreateDispatchers < ActiveRecord::Migration[5.1]
  def change
    create_table :dispatchers do |t|
      t.string :name
      t.timestamps
    end
  end
end
