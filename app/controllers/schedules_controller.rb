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
