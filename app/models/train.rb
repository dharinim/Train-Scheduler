class Train < ApplicationRecord
  has_many :train_schedules
  has_many :schedules, :through => :train_schedules

  belongs_to :dispatcher
  belongs_to :from_city, :foreign_key => "from_city_id", :class_name => "City"
  belongs_to :to_city, :foreign_key => "to_city_id", :class_name => "City"
end