class Vehicle < ActiveRecord::Base
  has_many :schedules
end
