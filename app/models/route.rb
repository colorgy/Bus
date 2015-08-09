class Route < ActiveRecord::Base
  has_many :schedules
  has_many :cart_items, class_name: 'UserCartItem'

  accepts_nested_attributes_for :schedules, allow_destroy: true

  validates_inclusion_of :direction, in: %w(North South)

  def display_name
    "#{origin} 到 #{destination}"
  end
end
