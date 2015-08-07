class Seat < ActiveRecord::Base
  belongs_to :vehicle
  has_many :orders
  has_many :cart_items, class_name: 'UserCartItem'

  def can_order?
    Order.find_by(seat: self).nil?
  end
end
