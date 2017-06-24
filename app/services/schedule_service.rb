module ScheduleService
  def find_train_schedules(criteria={})

    start_date     = criteria[:start_date]   || "2017-06-24"
    start_location = criteria[:from_city]    || 3
    end_location   = criteria[:to_city]      || 1
    max_days       = criteria[:max_days]     || 7

    day_count = 0
    available_trains = []

    current_start_date = start_date

    while day_count < max_days
      trains_on_single_day = _find_train_schedule(
                                  date = current_start_date,
                                  start_location = start_location,
                                  end_location = end_location
                              )
      
      available_trains << {
        date: current_start_date,
        day: Date.strptime(current_start_date, "%Y-%m-%d").day,
        day_of_the_week:  Date.parse(current_start_date).strftime("%A").downcase,
        trains: trains_on_single_day
      }
      
      day_count += 1
      day_added = Date.strptime(current_start_date, "%Y-%m-%d") + 1.day
      current_start_date = day_added.strftime("%Y-%m-%d")
    end

    return available_trains
  end

  def _find_train_schedule(
    date="2017-06-30",
    start_location=3,
    end_location=1
  )
    day = Date.strptime(date, "%Y-%m-%d").day
    week = _convert_day_to_week(day)
    day_of_the_week = Date.parse(date).strftime("%A").downcase
    day_of_the_week_enum = Schedule.day_of_the_weeks[day_of_the_week]

    # Frequency search
    frequencies_to_search = ["every_week"]

    # Bi-Weekly frequency search
    if week%2 == 1
      frequencies_to_search << "biweekly_odd_weeks"
    else
      frequencies_to_search << "biweekly_even_weeks"
    end

    # Monthly frequency search
    frequencies_to_search << "monthly_week" + week.to_s

    pluck_fields = {
      "schedules.departure_time": "departure_time",
      "trains.seats": "available_seats",
      "cities.name": "from_city",
      "to_cities_trains.name": "to_city",
      "dispatchers.name": "dispatcher_name",
      "day_of_the_week": "day_of_the_week"
    }.to_a

    pluck_fields_key = pluck_fields.map{|i| i[0]}
    pluck_fields_value = pluck_fields.map{|i| i[1]}

    schedules = TrainSchedule.joins(train: [:from_city, :to_city, :dispatcher]).
                                  joins(:schedule).
                                  where(schedules: { frequency: frequencies_to_search, day_of_the_week: day_of_the_week_enum }, 
                                        trains: {from_city_id: start_location, to_city_id: end_location} 
                                  ).pluck(*pluck_fields_key)

    # convert result to hash based in pluck_fields
    schedules = schedules.map{|pa| Hash[pluck_fields_value.zip(pa)]}

    for schedule in schedules
      if schedule["departure_time"]
        schedule["departure_time"] = schedule["departure_time"].strftime("%H:%M")
        schedule["day_of_the_week"] = Schedule.day_of_the_weeks.key(schedule["day_of_the_week"])
      end
    end

    return schedules
  end

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


    pluck_fields_key = pluck_fields.map{|i| i[0]}
    pluck_fields_value = pluck_fields.map{|i| i[1]}

    schedules = TrainSchedule.joins(train: [:from_city, :to_city, :dispatcher]).
                  joins(:schedule).
                  pluck(*pluck_fields_key)

    # convert result to hash based in pluck_fields
    schedules = schedules.map{|pa| Hash[pluck_fields_value.zip(pa)]}

    for schedule in schedules
      schedule["day_of_the_week"] =  Schedule.day_of_the_weeks.key(schedule["day_of_the_week"])
      schedule["departure_time"] = schedule["departure_time"].strftime("%H:%M")
    end

    return schedules
  end

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


class LocalRunner
  include ScheduleService

  def mymethod
    # find_train_schedules({
    #   start_date: "2017-06-25",
    #   from_city: 3,
    #   to_city: 1,
    #   max_days: 7
    # })

    _find_train_schedule

    # get_all_schedules
  end
end

p LocalRunner.new.mymethod