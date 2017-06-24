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

  enum occurance: {
    daily: 0,
    biweekly: 1,
    monthly: 2
  }

  enum occurance_type: {
    starts_daily: 0,
    starts_week1: 1,
    starts_week2: 2,
    starts_week3: 3,
    starts_week4: 4,
    starts_week5: 5
  }

# biweekly can only be 1 or 2
# monthly can be 1,2,3,4,5

  # Converting time to just hours minute
  def departure_time
    read_attribute(:departure_time).strftime("%H:%M")
  end
end
