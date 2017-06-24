class AddDispatcheridToTrain < ActiveRecord::Migration[5.1]
  def change
    add_column :trains, :dispatcher_id, :integer
  end
end
