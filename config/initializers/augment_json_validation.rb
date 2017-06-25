# We create all custom validation format required for the application

date_format_validator = -> value {
  begin  
    Date.strptime(value, "%Y-%m-%d")
  rescue
    raise JSON::Schema::CustomFormatError.new("Date format must be %Y-%m-%d")
  end  
}

city_id_format_validator = -> value {
  if value != nil
    for number in value.to_s.split('')
      if !["0", "1", "2", "3", "4", "5", "6", "7", "8", "9"].include?(number)
        raise JSON::Schema::CustomFormatError.new("City must be number format 0-9")
      end
    end
  end
}

JSON::Validator.register_format_validator("date_format", date_format_validator)
JSON::Validator.register_format_validator("city_id_format", city_id_format_validator)
