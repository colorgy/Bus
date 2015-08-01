class Order < ActiveRecord::Base
  belongs_to :schedule
  belongs_to :user
  belongs_to :bill

  validates :user, presence: true
  validates :schedule, presence: true
end
