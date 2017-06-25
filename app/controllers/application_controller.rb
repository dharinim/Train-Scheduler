class ValidateRequest
  def self.before(controller)
    schema = nil
    schemaModuleName = controller.controller_name[0..-2].capitalize +
                      "Schema::" +
                      controller.action_name.capitalize #ScheduleSchema::Trains

    begin
      schema = eval schemaModuleName
    rescue
      # Schema does not exist
    end
  
    if schema != nil
      data = JSON.parse(controller.params.to_json)
      validation_errors = JSON::Validator.fully_validate(schema, data)

      if validation_errors.length > 0
        errors = {
          error: "validation_error",
          messages: validation_errors
        }

        controller.render :json => errors, status: :bad_request
      end   
    end
  end
end

class AccessLog
  def self.before(controller)
    # Can log request without PII
    controller.logger.info({
      controller: controller.controller_name,
      action: controller.action_name
    });
  end
end

class StatsEmitter
  def self.before(controller)
    # increments request.count.schedule.action.trains
    $statsd.increment 'request.count.'+ controller.controller_name + ".action." + controller.action_name
  end

  def self.around(controller)
    # Emit appropriate stats
    yield
  end

  def self.after(controller)
    # Emit appropriate stats
  end
end

class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  before_action ::ValidateRequest
  before_action ::AccessLog

  before_action ::StatsEmitter
  around_action ::StatsEmitter
  after_action  ::StatsEmitter
end

