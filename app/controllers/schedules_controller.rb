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



end
