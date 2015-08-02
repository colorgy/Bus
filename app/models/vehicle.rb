class Vehicle < ActiveRecord::Base
  has_many :schedules
  has_many :orders
  has_many :seats

  accepts_nested_attributes_for :schedules, :seats, allow_destroy: true
end
