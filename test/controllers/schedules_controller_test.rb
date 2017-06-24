require 'test_helper'

class SchedulesControllerTest < ActionDispatch::IntegrationTest
  test "show all schedules by all dispatchers" do
    get "/schedules", as: :json

    expectedRepsonse = {
      "id"=>1,
      "day_of_the_week"=>"monday",
      "departure_time"=>"07:00",
      "schedule_frequency"=>"every_week",
      "available_seats"=>50,
      "from_city"=>"San Francisco",
      "to_city"=>"Los Angels",
      "dispatcher_name"=>"FunTime"
    }

    r = JSON.parse(response.body)
    assert_equal 200, response.status
    assert_equal 34, r["schedules"].length
    assert_equal expectedRepsonse, r["schedules"].first
  end

  test "show possible trains for given date" do
    get "/schedules/trains?start_date=2017-07-25", as: :json

    # Expected trains on "2017-07-25"
    expectedTrains =  [
        {
            "departure_time" => "08:00",
            "available_seats" => 100,
            "from_city" => "San Francisco",
            "to_city" => "Seattle",
            "dispatcher_name" => "BlueMoon",
            "day_of_the_week"=> "tuesday"
        },
        {
            "departure_time" => "08:00",
            "available_seats" => 100,
            "from_city" => "San Francisco",
            "to_city" => "Seattle",
            "dispatcher_name" => "BlueMoon",
            "day_of_the_week" => "tuesday"
        }
    ]

    r = JSON.parse(response.body)
    assert_equal 200, response.status
    assert_equal 8, r["train_schedules"].length
    assert_equal expectedTrains, r["train_schedules"].first["trains"]
  end

  test "show trains with from and to city" do
    get "/schedules/trains?start_date=2017-06-09&from_city=4&to_city=1", as: :json

    # Expected trains on "2017-07-25"
    expectedTrains =  [
      {
        "departure_time"=>"14:15",
        "available_seats"=>50,
        "from_city"=>"Las Vegas",
        "to_city"=>"San Francisco",
        "dispatcher_name"=>"BlueMoon",
        "day_of_the_week"=>"saturday"
      }
    ]

    r = JSON.parse(response.body)
    assert_equal 200, response.status
    assert_equal 8, r["train_schedules"].length
    assert_equal expectedTrains, r["train_schedules"][1]["trains"]
  end

  test "No trains with from and to city" do
    get "/schedules/trains?start_date=2017-06-09&from_city=9&to_city=1", as: :json

    # Expected trains on "2017-07-25"
    expectedTrains =  []

    r = JSON.parse(response.body)
    assert_equal 200, response.status
    assert_equal 8, r["train_schedules"].length
    assert_equal expectedTrains, r["train_schedules"][1]["trains"]
  end
end
