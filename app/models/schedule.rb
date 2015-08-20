class Schedule < ActiveRecord::Base
  has_many :cart_items, class_name: 'UserCartItem', dependent: :destroy
  has_many :orders
  has_many :ordered_users, class_name: 'User', through: :orders, source: :schedule

  belongs_to :route
  belongs_to :vehicle

  just_define_datetime_picker :departure_time, :add_to_attr_accessor => true
  validates :departure_time, presence: true

  def available?
    # or one schedule have some limited
    Order.where(schedule: self, vehicle: self.vehicle).count < self.vehicle.seats.count
  end

  def available_seats_count
    self.vehicle.seats.count - Order.where(schedule: self, vehicle: self.vehicle).count
  end

  def seat_count
    self.vehicle.seats.count
  end
end
