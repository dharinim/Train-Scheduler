# Dispatcher represents a company or an agency that runs a particular train line.
# @attr id              [Integer] Autoincrements
# @attr day_of_the_week [Enum] Represents day of the week. Monday => 0 .. Saturday => 6
# @attr departure_time  [Time] The time when a train leaves, Time represented as %H-%M-%S.
# @attr frequency       [String] Represents a string describing a recurring schedule, look at details below. 
#                       Possible values are:
#                       - *every_week*: (every week on the given {day_of_the_week}).
#                       - *biweekly_odd_weeks*: (every {day_of_the_week} on week1, week3 and week5).
#                       - *biweekly_even_weeks*: (every {day_of_the_week} on week2 and week4).
#                       - *monthly_week1*: (every {day_of_the_week} in the week1 of the month).
#                       - *monthly_week2*: (every {day_of_the_week} in the week2 of the month).
#                       - *monthly_week3*: (every {day_of_the_week} in the week3 of the month).
#                       - *monthly_week4*: (every {day_of_the_week} in the week4 of the month).
#                       - *monthly_week5*: (every {day_of_the_week} in the week5 of the month).
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

  # @!visibility private
  # Converting time to just hours minute
  def departure_time
    read_attribute(:departure_time).strftime("%H:%M")
  end
end
