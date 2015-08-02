class Seat < ActiveRecord::Base
  belongs_to :vehicle
  has_many :orders
  has_many :cart_items, class_name: 'UserCartItem'
end
