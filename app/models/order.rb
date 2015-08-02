class Order < ActiveRecord::Base
  belongs_to :schedule
  belongs_to :user
  belongs_to :bill
  belongs_to :vehicle
  belongs_to :seat

  validates :user, presence: true
  validates :schedule, presence: true

  validates_uniqueness_of :seat_id, scope: [:schedule_id, :bill_id, :vehicle_id]
end
