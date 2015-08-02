class Vehicle < ActiveRecord::Base
  has_many :schedules
  has_many :orders
  has_many :seats
end
