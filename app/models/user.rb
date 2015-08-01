class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :cart_items, class_name: 'UserCartItem'
  has_many :orders
  has_many :ordered_schedules, class_name: 'Schedule', through: :orders
  has_many :bills
end
