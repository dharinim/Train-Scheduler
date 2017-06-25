module ScheduleService
  # Given a day, calculate all possible trains
  # running for the next week. Duration is configurable.
  # @option params start_date
  # @option params from_city
  # @option params to_city
  # @option params max_days
  def find_train_schedules(criteria={})

    current_start_date = criteria[:start_date]   || "2017-06-24"
    start_location     = criteria[:from_city]    || 1
    end_location       = criteria[:to_city]      || 3
    max_days           = criteria[:max_days]     || 7

    train_schedules = []
    for i in 0..max_days
      trains_on_single_day = _find_train_schedule(current_start_date, start_location, end_location)
      
      train_schedules << {
        date: current_start_date,
        day: _string_to_date(current_start_date).day,
        day_of_the_week:  _day_of_the_week(current_start_date),
        trains: trains_on_single_day
      }
      
      current_start_date = _increment_date(current_start_date)
    end

    return train_schedules
  end

  # Get all schedules configured by the dispatcher
  def get_all_schedules
    pluck_fields = {
      "id": "id",
      "day_of_the_week": "day_of_the_week",
      "schedules.departure_time": "departure_time",
      "frequency": "schedule_frequency",
      "trains.seats": "available_seats",
      "cities.name": "from_city",
      "to_cities_trains.name": "to_city",
      "dispatchers.name": "dispatcher_name"
    }.to_a

    query = TrainSchedule.joins(train: [:from_city, :to_city, :dispatcher]).
                   joins(:schedule)
                   

    return _execute_schedule_query(query, pluck_fields)              
  end

  # Given a date, start location and end location
  # Find all trains running on that day.
  def _find_train_schedule(date = "2017-06-30", start_location = 3, end_location = 1)
    day = _string_to_date(date).day
    week = _convert_day_to_week(day)
    
    frequencies_to_search = []
    frequencies_to_search << "every_week"
    frequencies_to_search << "biweekly_odd_weeks" if week%2 == 1
    frequencies_to_search << "biweekly_even_weeks"  if week%2 != 1
    frequencies_to_search << "monthly_week" + week.to_s

    pluck_fields = {
      "schedules.departure_time": "departure_time",
      "trains.seats": "available_seats",
      "cities.name": "from_city",
      "to_cities_trains.name": "to_city",
      "dispatchers.name": "dispatcher_name",
      "day_of_the_week": "day_of_the_week"
    }.to_a

    day_of_the_week = _day_of_the_week(date)
    day_of_the_week_enum = Schedule.day_of_the_weeks[day_of_the_week]

    query = TrainSchedule.joins(train: [:from_city, :to_city, :dispatcher]).
                                  joins(:schedule).
                                  where(schedules: { frequency: frequencies_to_search, day_of_the_week: day_of_the_week_enum }, 
                                        trains: {from_city_id: start_location, to_city_id: end_location} 
                                  )

    return _execute_schedule_query(query, pluck_fields)
  end

  # @!visibility private
  # Get a active record query, runs and converts the 
  # plucked array into a hash for returning.
  def _execute_schedule_query(query, pluck_fields)
    pluck_fields_key = pluck_fields.map{|i| i[0]}
    pluck_fields_value = pluck_fields.map{|i| i[1]}

    # convert result to hash based in pluck_fields
    query = query.pluck(*pluck_fields_key)
    schedules = query.map{|pa| Hash[pluck_fields_value.zip(pa)]}
    schedules = _normalize_keys(schedules)

    return schedules
  end

  # @!visibility private
  # Perform standard transformation for display
  def _normalize_keys(schedules)
    for schedule in schedules
      schedule["day_of_the_week"] =  Schedule.day_of_the_weeks.key(schedule["day_of_the_week"])
      schedule["departure_time"] = schedule["departure_time"].strftime("%H:%M")
    end
  end

  # @!visibility private
  # Used in converting enum to day
  def _day_of_the_week(date)
    Date.parse(date).strftime("%A").downcase
  end

  # @!visibility private
  def _increment_date(date)
      day_added = _string_to_date(date) + 1.day
      return day_added.strftime("%Y-%m-%d")
  end

  # @!visibility private
  def _string_to_date(string_date, format= "%Y-%m-%d")
    Date.strptime(string_date, "%Y-%m-%d")
  end

  # @!visibility private
  def _convert_day_to_week(day)
    case day
      when 0..7 then week = 1
      when 8..14 then week = 2
      when 15..21 then week = 3
      when 22..28 then week = 4
      else week = 5
    end

    return week
  end
end


# class LocalRunner
#   include ScheduleService

#   def mymethod
#     find_train_schedules({
#       start_date: "2017-06-25",
#       from_city: 3,
#       to_city: 1,
#       max_days: 7
#     })

#     _find_train_schedule

#     get_all_schedules
#   end
# end

# p LocalRunner.new.mymethod