class Route < ActiveRecord::Base
  has_many :schedules

  accepts_nested_attributes_for :schedules
end
