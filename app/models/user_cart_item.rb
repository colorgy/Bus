class UserCartItem < ActiveRecord::Base
  belongs_to :user, counter_cache: :cart_items_count
  belongs_to :schedule
  belongs_to :seat
  belongs_to :route

  validates :quantity, numericality: { greater_than: 0, less_than: 4 }
end
