class HomepageController < ApplicationController
  include ScheduleService

  # This method serves the route '/'.
  def index
    @schedules = get_all_schedules

    respond_to do |format|
      format.html
    end
  end
end
