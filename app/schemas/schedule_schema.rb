# Validates {SchedulesController#trains}
module ScheduleSchema
  Trains = {
    "type" => "object",
    "properties" => {
      "start_date" => {
        "type" => "string",
        "format" => "date_format"
      },
      "from_city" => {
        "type" => "string",
        "format" => "city_id_format"
      },
      "to_city" => {
        "type" => "string",
        "format" => "city_id_format"
      },
      "controller" => {
        "type" => "string"
      },
      "action" => {
        "type" => "string"
      }
    },
    "required" => ["start_date", "from_city", "to_city"],
  }
end