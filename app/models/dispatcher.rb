# Dispatcher represents a company or an agency that runs a particular train line.
# @attr id   [Integer] Autoincrements
# @attr name [String]  Name of a dispatcher
class Dispatcher < ApplicationRecord
  has_many :trains
end
