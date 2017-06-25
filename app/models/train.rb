# A single train between two cities. Schedule for this train is linked via {TrainSchedule} to a recurring {Schedule}.
# @attr id   [Integer] Autoincrements
# @attr from_city [Integer]  The start city of the train links to {City}
# @attr to_city [Integer]  Destination city of the train links to {City}
# @attr dispatcher_id [Integer]  The dispatcher of the train links to {Dispatcher}
class Train < ApplicationRecord
  has_many :train_schedules
  has_many :schedules, :through => :train_schedules

  belongs_to :dispatcher
  belongs_to :from_city, :foreign_key => "from_city_id", :class_name => "City"
  belongs_to :to_city, :foreign_key => "to_city_id", :class_name => "City"
end