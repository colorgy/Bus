class Route < ActiveRecord::Base
  has_many :schedules
  has_many :cart_items, class_name: 'UserCartItem'

  accepts_nested_attributes_for :schedules
end
