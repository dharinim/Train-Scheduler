class Schedule < ApplicationRecord
  has_many :train_schedules
  has_many :trains, :through => :train_schedules

  enum day_of_the_week: {
    monday: 0,
    tuesday: 1,
    wednesday: 2,
    thursday: 3,
    friday: 4,
    saturday: 5,
    sunday: 6
  }

  # Converting time to just hours minute
  def departure_time
    read_attribute(:departure_time).strftime("%H:%M")
  end
end
