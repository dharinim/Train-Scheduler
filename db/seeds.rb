# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).

Train.delete_all
Schedule.delete_all
Dispatcher.delete_all
City.delete_all
TrainSchedule.delete_all

Train.connection.execute('ALTER SEQUENCE trains_id_seq RESTART WITH 1')
Schedule.connection.execute('ALTER SEQUENCE schedules_id_seq RESTART WITH 1')
Dispatcher.connection.execute('ALTER SEQUENCE dispatchers_id_seq RESTART WITH 1')
City.connection.execute('ALTER SEQUENCE cities_id_seq RESTART WITH 1')
TrainSchedule.connection.execute('ALTER SEQUENCE cities_id_seq RESTART WITH 1')

def get_city(name)
  City.find_by_name(name).id
end

def get_dispatcher(name)
  Dispatcher.find_by_name(name).id
end

def get_day(day)
  Schedule.day_of_the_weeks[day]
end

def seed_dataset(data, model)
  for row in data
    model.create!(row)
  end
end

seed_data_without_relationships = {
  city: [
    {id: 1, name: 'San Francisco'},
    {id: 2, name: 'Los Angels'},
    {id: 3, name: 'Seattle'},
    {id: 4, name: 'Las Vegas'},
    {id: 5, name: 'New Jersey'},
  ],
  dispatchers: [
    {id: 1, name: 'BlueMoon'},
    {id: 2, name: 'The Giants'},
    {id: 3, name: 'FunTime'}
  ]
}

seed_dataset(seed_data_without_relationships[:city], City)
seed_dataset(seed_data_without_relationships[:dispatchers], Dispatcher)

seed_data = {
  trains: [
      {id: 1, from_city_id: get_city("San Francisco"), to_city_id: get_city('Los Angels'), seats: 50, dispatcher_id: get_dispatcher('FunTime')},
      {id: 2, from_city_id: get_city("San Francisco"), to_city_id: get_city('Seattle'), seats: 100, dispatcher_id: get_dispatcher('BlueMoon')},
      {id: 3, from_city_id: get_city("San Francisco"), to_city_id: get_city('Las Vegas'), seats: 50, dispatcher_id: get_dispatcher('The Giants')},
      {id: 4, from_city_id: get_city("San Francisco"), to_city_id: get_city('New Jersey'), seats: 50, dispatcher_id: get_dispatcher('FunTime')},

      {id: 5, from_city_id: get_city("Los Angels"),       to_city_id: get_city('San Francisco'), seats: 50, dispatcher_id: get_dispatcher('BlueMoon')},
      {id: 6, from_city_id: get_city("Los Angels"),       to_city_id: get_city('Seattle'), seats: 150, dispatcher_id: get_dispatcher('The Giants')},
      {id: 7, from_city_id: get_city("Los Angels"),       to_city_id: get_city('Las Vegas'), seats: 50, dispatcher_id: get_dispatcher('FunTime')},
      {id: 8, from_city_id: get_city("Los Angels"),       to_city_id: get_city('New Jersey'), seats: 50, dispatcher_id: get_dispatcher('BlueMoon')},

      {id: 9, from_city_id: get_city("Seattle"),       to_city_id: get_city('San Francisco'), seats: 50, dispatcher_id: get_dispatcher('FunTime')},
      {id: 10, from_city_id: get_city("Seattle"),       to_city_id: get_city('Los Angels'), seats: 50, dispatcher_id: get_dispatcher('BlueMoon')},
      {id: 11, from_city_id: get_city("Seattle"),       to_city_id: get_city('Las Vegas'), seats: 75, dispatcher_id: get_dispatcher('The Giants')},
      {id: 12, from_city_id: get_city("Seattle"),       to_city_id: get_city('New Jersey'), seats: 50, dispatcher_id: get_dispatcher('FunTime')},
      
      {id: 13, from_city_id: get_city("Las Vegas"),       to_city_id: get_city('San Francisco'), seats: 50, dispatcher_id: get_dispatcher('BlueMoon')},
      {id: 14, from_city_id: get_city("Las Vegas"),       to_city_id: get_city('New Jersey'), seats: 25, dispatcher_id: get_dispatcher('The Giants')},

      {id: 15, from_city_id: get_city("New Jersey"),       to_city_id: get_city('San Francisco'), seats: 50, dispatcher_id: get_dispatcher('FunTime')},
      {id: 16, from_city_id: get_city("New Jersey"),       to_city_id: get_city('Las Vegas'), seats: 50, dispatcher_id: get_dispatcher('BlueMoon')}
  ],
  schedules: [
    {id: 1, day_of_the_week: get_day("monday"), frequency: 'every_week', departure_time: '07:00'},
    {id: 2, day_of_the_week: get_day("tuesday"), frequency: 'every_week', departure_time: '08:00'},
    {id: 3, day_of_the_week: get_day("wednesday"), frequency: 'every_week', departure_time: '09:00'},
    {id: 4, day_of_the_week: get_day("thursday"), frequency: 'every_week', departure_time: '10:00'},
    {id: 5, day_of_the_week: get_day("friday"), frequency: 'every_week', departure_time: '11:00'},
    {id: 6, day_of_the_week: get_day("saturday"), frequency: 'every_week', departure_time: '12:00'},
    {id: 7, day_of_the_week: get_day("sunday"), frequency: 'every_week', departure_time: '13:00'},

    {id: 8, day_of_the_week: get_day("monday"),    frequency: 'biweekly_odd_weeks', departure_time: '10:15'},
    {id: 9, day_of_the_week: get_day("tuesday"),   frequency: 'biweekly_odd_weeks', departure_time: '10:15'},

    {id: 10, day_of_the_week: get_day("wednesday"), frequency: 'biweekly_even_weeks', departure_time: '14:15'},
    {id: 11, day_of_the_week: get_day("thursday"), frequency: 'biweekly_even_weeks', departure_time: '14:15'},
    
    {id: 12, day_of_the_week: get_day("friday"), frequency: 'monthly_week1', departure_time: '14:15'},
    {id: 13, day_of_the_week: get_day("saturday"), frequency: 'monthly_week2', departure_time: '14:15'},
    {id: 14, day_of_the_week: get_day("sunday"), frequency: 'monthly_week3', departure_time: '14:15'},
    {id: 15, day_of_the_week: get_day("tuesday"), frequency: 'monthly_week4', departure_time: '14:15'},
    {id: 16, day_of_the_week: get_day("monday"), frequency: 'monthly_week5', departure_time: '14:15'}
  ],

  trains_schedules: [
    {id: 1, train_id: 1, schedule_id: 1},
    {id: 2, train_id: 2, schedule_id: 2},
    {id: 3, train_id: 3, schedule_id: 3},
    {id: 4, train_id: 4, schedule_id: 4},
    {id: 5, train_id: 5, schedule_id: 5},
    {id: 6, train_id: 6, schedule_id: 6},
    {id: 7, train_id: 7, schedule_id: 7},
    {id: 8, train_id: 8, schedule_id: 8},
    {id: 9, train_id: 9, schedule_id: 9},
    {id: 10, train_id: 10, schedule_id: 10},
    {id: 11, train_id: 11, schedule_id: 11},
    {id: 12, train_id: 12, schedule_id: 12},
    {id: 13, train_id: 13, schedule_id: 13},
    {id: 14, train_id: 14, schedule_id: 14},
    {id: 15, train_id: 15, schedule_id: 15},
    {id: 16, train_id: 16, schedule_id: 16},
    {id: 17, train_id: 1, schedule_id: 1},
    {id: 18, train_id: 1, schedule_id: 2},
    {id: 19, train_id: 1, schedule_id: 3},
    {id: 20, train_id: 2, schedule_id: 1},
    {id: 21, train_id: 2, schedule_id: 2},
    {id: 22, train_id: 2, schedule_id: 7},
    {id: 23, train_id: 3, schedule_id: 1},
    {id: 24, train_id: 3, schedule_id: 4},
    {id: 25, train_id: 3, schedule_id: 7},
    {id: 26, train_id: 4, schedule_id: 1},
    {id: 27, train_id: 4, schedule_id: 2},
    {id: 28, train_id: 4, schedule_id: 7},
    {id: 29, train_id: 5, schedule_id: 1},
    {id: 30, train_id: 5, schedule_id: 2},
    {id: 31, train_id: 5, schedule_id: 3},
    {id: 32, train_id: 6, schedule_id: 1},
    {id: 33, train_id: 6, schedule_id: 2},
    {id: 34, train_id: 6, schedule_id: 7}
  ]
}

seed_dataset(seed_data[:trains], Train)
seed_dataset(seed_data[:schedules], Schedule)
seed_dataset(seed_data[:trains_schedules], TrainSchedule)



