class Schedule < ActiveRecord::Base
  has_many :cart_items, class_name: 'UserCartItem'
  has_many :orders
  has_many :ordered_users, class_name: 'User', through: :orders, source: :schedule

  belongs_to :route
  belongs_to :vehicle

  just_define_datetime_picker :departure_time, :add_to_attr_accessor => true
  validates :departure_time, presence: true
end
