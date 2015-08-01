class Schedule < ActiveRecord::Base
  has_many :cart_items, class_name: 'UserCartItem'
  has_many :orders
  has_many :ordered_users, class_name: 'User', through: :orders, source: :schedule

  belongs_to :route
  belongs_to :vehicle
end
