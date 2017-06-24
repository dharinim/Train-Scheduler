class SchedulesController < ApplicationController
  include ScheduleService

  def index
    schedules = get_all_schedules

    response = {
      schedules: schedules
    }

    respond_to do |format|
      format.json  { render :json => response}
    end
  end

  def trains
    criteria = {
      start_date: params[:start_date],
      max_days: params[:max_days],
      from_city_id: params[:from_city_id],
      to_city_id: params[:to_city_id],
    }

    p criteria

    trains = find_train_schedules(criteria)

    respond_to do |format|
      format.json  { render :json => trains}
    end
  end
end
