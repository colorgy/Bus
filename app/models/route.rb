class Route < ActiveRecord::Base
  has_many :schedules
  has_many :cart_items, class_name: 'UserCartItem'

  accepts_nested_attributes_for :schedules, allow_destroy: true

  def display_name
    "從 #{origin} 到 #{destination}"
  end
end
