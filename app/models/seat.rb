class Seat < ActiveRecord::Base
  belongs_to :vehicle
  has_many :orders, foreign_key: :seat_no
  has_many :cart_items, class_name: 'UserCartItem'

  def can_order? user: nil
    Order.find_by(seat: self).nil? && user && user.cart_items.find_by(seat_id: self.id).nil?
  end
end
