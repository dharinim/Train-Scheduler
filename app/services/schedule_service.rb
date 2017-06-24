require 'date'

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

  def _find_train_schedule(date="2017-06-24", start_location=start_location, end_location=end_location)
    day = Date.strptime(date, "%Y-%m-%d").day
    week = _convert_day_to_week(day)
    day_of_the_week = Date.parse(date).strftime("%A").downcase
    day_of_the_week_enum = Schedule.day_of_the_weeks[day_of_the_week]
    p day_of_the_week, day_of_the_week_enum


    #TrainSchedule.joins(train: [:from_city, :to_city, :dispatcher]).
    #joins(:schedule).pluck("cities.name", "to_cities_trains.name", "dispatchers.name", "trains.seats")

    required_fields = [
      "schedules.departure_time",
      "trains.seats",
      "cities.name",
      "to_cities_trains.name",
      "dispatchers.name"
    ]

    # Preserve order with required_fields
    user_friendly_required_fields = [
      "departure_time",
      "available_seats",
      "from_city",
      "to_city",
      "dispatcher_name"
    ]

  TrainSchedule.joins(train: [:from_city, :to_city, :dispatcher]).joins(:schedule).where(schedules: { occurance: 0, day_of_the_week: 5 }).pluck(*required_fields)

    monthly_trains = TrainSchedule.joins(train: [:from_city, :to_city, :dispatcher]).
                                  joins(:schedule).
                                  where(schedules: { occurance_type: week, occurance: 2, day_of_the_week: day_of_the_week_enum }, 
                                        trains: {from_city_id: start_location, to_city_id: end_location} 
                                  ).pluck(*required_fields)

    if (week == 1 || week == 3 || week == 5)                            
      biweekly_week = 1
    elsif (week == 2 || week == 4)
      biweekly_week = 2
    end
    biweekly_trains = TrainSchedule.joins(train: [:from_city, :to_city, :dispatcher]).
                                  joins(:schedule).
                                  where(schedules: { occurance_type: biweekly_week, occurance: 1, day_of_the_week: day_of_the_week_enum }, 
                                        trains: {from_city_id: start_location, to_city_id: end_location} 
                                  ).pluck(*required_fields)

    daily_trains = TrainSchedule.joins(train: [:from_city, :to_city, :dispatcher]).
                                  joins(:schedule).
                                  where(schedules: { occurance: 0, day_of_the_week: day_of_the_week_enum }, 
                                        trains: {from_city_id: start_location, to_city_id: end_location} 
                                  ).pluck(*required_fields)

    # monthly_trains = TrainSchedule.joins(:train).
    #                               joins(:schedule).
    #                               where(schedules: { occurance_type: week, occurance: 2, day_of_the_week: day_of_the_week_enum }, 
    #                                     trains: {from_city_id: start_location, to_city_id: end_location} 
    #                               )
    #                               p monthly_trains.count

    # biweekly_trains = TrainSchedule.joins(:train).
    #                               joins(:schedule).
    #                               where(schedules: { occurance_type: week, occurance: 1, day_of_the_week: day_of_the_week_enum }, 
    #                                     trains: {from_city_id: start_location, to_city_id: end_location} 
    #                               )

    # daily_trains = TrainSchedule.joins(:train).
    #                               joins(:schedule).
    #                               where(schedules: { occurance: 0, day_of_the_week: day_of_the_week_enum }, 
    #                                     trains: {from_city_id: start_location, to_city_id: end_location} 
    #                               )

    available_trains = monthly_trains + biweekly_trains + daily_trains
    available_trains = available_trains.map{|pa| Hash[user_friendly_required_fields.zip(pa)]}

    for available_train in available_trains
      if available_train["departure_time"]
        available_train["departure_time"] = available_train["departure_time"].strftime("%H:%M")
      end
    end

    return available_trains
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

  # def get_all_schedules(
  #   fields=[
  #     "id",
  #     "day_of_the_week",
  #     "departure_time" ,
  #     "occurance",
  #     "occurance_type"
  #   ]
  # )
  #   Schedule.select(fields.join(',')).all()
  # end

  def get_all_schedules(
    fields=[
      "id",
      "day_of_the_week",
      "departure_time" ,
      "occurance",
      "occurance_type",
      "trains.seats",
      "cities.name",
      "to_cities_trains.name",
      "dispatchers.name"
    ]
  )

    user_friendly_required_fields = [
      "id",
      "day_of_the_week",
      "departure_time",
      "occurance",
      "occurance_type",
      "available_seats",
      "from_city",
      "to_city",
      "dispatcher_name"
    ]

    train_schedules = TrainSchedule.joins(train: [:from_city, :to_city, :dispatcher]).
                  joins(:schedule).
                  pluck(*fields)
    # train_schedules = train_schedules.map{|pa| Hash[fields.zip(pa)]}

    train_schedules = train_schedules.map{|pa| Hash[user_friendly_required_fields.zip(pa)]}

    for train_schedule in train_schedules
      train_schedule["day_of_the_week"] =  Schedule.day_of_the_weeks.key(train_schedule["day_of_the_week"])
      train_schedule["occurance"] = Schedule.occurances.key(train_schedule["occurance"])
      train_schedule["occurance_type"] = Schedule.occurance_types.key(train_schedule["occurance_type"])
      train_schedule["departure_time"] = train_schedule["departure_time"].strftime("%H:%M")
    end

    return train_schedules
  end
end

class LocalRunner
  include ScheduleService

  def mymethod
    find_train_schedules
  end
end

p LocalRunner.new.mymethod