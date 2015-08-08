class Seat < ActiveRecord::Base
  belongs_to :vehicle
  has_many :orders, foreign_key: :seat_no
  has_many :cart_items, class_name: 'UserCartItem'

  def can_order?
    Order.find_by(seat: self).nil?
  end
end
