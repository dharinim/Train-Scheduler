#  The API endpoints to interact with schdules of trains.
class SchedulesController < ApplicationController
  include ScheduleService

  # Returns all available recurring schedules of
  # all trains. This method serves the route "/schedules/".
  def index
    schedules = get_all_schedules

    response = {
      schedules: schedules
    }

    respond_to do |format|
      format.json  { render :json => response}
    end
  end

  # Returns all train trips available for booking
  # for a given date, start and destination city.
  # This API is validated using {ScheduleSchema}
  # This method serves the route "/schedules/trains".
  # @option params start_date
  # @option params from_city
  # @option params to_city
  # @option params max_days
  def trains
    criteria = {
      start_date: params[:start_date],
      max_days: params[:max_days],
      from_city: params[:from_city],
      to_city: params[:to_city],
    }

    response = {
      train_schedules: find_train_schedules(criteria)
    }

    respond_to do |format|
      format.json  { render :json => response}
    end
  end
end
