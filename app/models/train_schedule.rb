class TrainSchedule < ApplicationRecord
  belongs_to :schedule
  belongs_to :train
end
