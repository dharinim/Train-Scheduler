require 'date'

module ScheduleService  
  available_trains = []
  def self.find_train_schedules(start_date="2017-06-24", start_location=1, end_location=2, available_trains = [])
    day_count = 0
    while day_count < 7
      find_week = (start_date[-2] + start_date[-1]).to_i
      case find_week
        when 0..7 then week = 1
        when 8..14 then week = 2
        when 15..21 then week = 3
        when 22..28 then week = 4
        else week = 5
      end

      find_day = Date.parse(start_date).strftime("%A").downcase
      case find_day
        when "monday" then day = 0
        when "tuesday" then day = 2
        when "wednesday" then day = 3
        when "thursday" then day = 4
        when "friday" then day = 2
        when "saturday" then day = 3
        when "sunday" then day = 4
      end
      p "*" * 25
      p "date is #{find_week}, week is #{week}, day is #{day}"
      p "*" * 25
      
      monthly_train = Schedule.find_by(occurance: 2, occurance_type: week, day_of_the_week: day) #typr 1,2,3,4,5
      weekly_train = Schedule.find_by(occurance: 1, occurance_type: week, day_of_the_week: day) #type 1 or 2
      daily_train = Schedule.find_by(occurance: 0, day_of_the_week: day)
      available_trains << monthly_train << weekly_train << daily_train


      day_count += 1
      day_added = Date.strptime(start_date, "%Y-%m-%d") + 1.day
      new_start_date = day_added.strftime("%Y-%m-%d")
      start_date = new_start_date
    end
     #starting from start date, next 6 days
    return available_trains
  end

  def get_all_schedules(
    fields=[
      "id",
      "day_of_the_week",
      "departure_time" ,
      "occurance",
      "occurance_type"
    ]
  )
    Schedule.select(fields.join(',')).all()
  end
end



p ScheduleService.find_train_schedules