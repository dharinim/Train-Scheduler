# Represents a {Train} on a recurring {Schedule}
# @attr id   [Integer] Autoincrements
# @attr schedule_id [Integer] Schedule at which this train runs.
# @attr train_id [Integer] Train details of this schedule.
class TrainSchedule < ApplicationRecord
  belongs_to :schedule
  belongs_to :train
end
