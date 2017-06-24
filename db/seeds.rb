# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
Train.delete_all
Schedule.delete_all
Dispatcher.delete_all
City.delete_all

Train.connection.execute('ALTER SEQUENCE trains_id_seq RESTART WITH 1')
Schedule.connection.execute('ALTER SEQUENCE schedules_id_seq RESTART WITH 1')
Dispatcher.connection.execute('ALTER SEQUENCE dispatchers_id_seq RESTART WITH 1')
City.connection.execute('ALTER SEQUENCE cities_id_seq RESTART WITH 1')

day = {
  'monday' => 0,
  'tuesday' => 1,
  'wednesday' => 2,
  'thursday' => 3,
  'friday' => 4,
  'saturday' => 5,
  'sunday' => 6
}

occurance = {
  'daily' => 0,
  'biweekly' => 1,
  'monthly' => 2
}

occurance_type = {
  'starts_daily' => 0,
  'starts_week1' => 1,
  'starts_week2' => 2,
  'starts_week3' => 3,
  'starts_week4' => 4,
  'starts_week5' => 5
}

time = ['07:45:00', '11:00:00', '14:00:00', '22:00:00', '05:30:00', '10:15:00', '09:30:00']
cities = ["San Francisco", "Los Angels", "Seattle", "Las Vegas", "New Jersey"]

def seed_schedule(day, occurance, occurance_type, time)
  for i in 0..10
    day_keys = day.keys
    random_day = day[day_keys[rand(day_keys.length)]]

    occurance_keys = occurance.keys
    random_occurance = occurance[occurance_keys[rand(occurance_keys.length)]]

    occurance_type_keys = occurance_type.keys
    random_occurance_type = occurance_type[occurance_type_keys[rand(occurance_type_keys.length)]]
    random_time = time[rand(time.length)]
    Schedule.create(day_of_the_week: random_day, departure_time: random_time, occurance: random_occurance, occurance_type: random_occurance_type)
  end
end

def seed_cities(cities)
  for city in cities
    City.create(name: city)
  end
end

def get_city(name)
  City.find_by_name(name).id
end

def seed_train
  Train.create(from_city_id: get_city("San Francisco"), to_city_id: get_city('Los Angels'), seats: 50, dispatcher_id: 0)
  Train.create(from_city_id: get_city("San Francisco"), to_city_id: get_city('Las Vegas'), seats: 50, dispatcher_id: 1)
  Train.create(from_city_id: get_city('Seattle'), to_city_id: get_city("San Francisco"), seats: 50, dispatcher_id: 1)
  Train.create(from_city_id: get_city("San Francisco"), to_city_id: get_city('Seattle'), seats: 50, dispatcher_id: 2)
  Train.create(from_city_id: get_city('New Jersey'), to_city_id: get_city("San Francisco"), seats: 50, dispatcher_id: 0)
end

def seed_dispatcher
  Dispatcher.create(name: 'BlueMoon')
  Dispatcher.create(name: 'The Giants')
  Dispatcher.create(name: 'FunTime')
end

seed_cities(cities)
seed_schedule(day, occurance, occurance_type, time)
seed_train
seed_dispatcher



