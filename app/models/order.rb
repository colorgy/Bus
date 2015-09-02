class Order < ActiveRecord::Base
  include AASM

  acts_as_paranoid
  has_paper_trail

  belongs_to :schedule
  belongs_to :user
  belongs_to :bill, counter_cache: true
  belongs_to :vehicle
  belongs_to :seat, foreign_key: :seat_no, primary_key: :seat_no

  validates :user, presence: true
  validates :schedule, presence: true

  validates_uniqueness_of :seat_no, scope: [:schedule_id, :bill_id, :vehicle_id], conditions: -> { where('state = ? OR state = ?', "payment_pending", "paid") }

  scope :ordered, -> { where('state = ? OR state = ?', "payment_pending", "paid") }

  # borrow codes from Colorgy Book
  aasm column: :state do
    state :payment_pending, initial: true  # has a non-expired bill
    state :expired  # invalid order, dead state
    state :paid  # paid, but can be refund automatically
    state :ready  # order processing, cannot be refund automatically
    state :canceled  # the order has been canceled and refunded (if paid)
    state :refunded

    # event :bill_created do
    #   transitions :from => :new, :to => :payment_pending
    #   transitions :from => :payment_pending, :to => :payment_pending
    # end

    event :pay do
      # transitions :from => :new, :to => :paid
      transitions :from => :payment_pending, :to => :paid
    end

    event :ready do
      transitions :from => :paid, :to => :ready
      transitions :from => :expired, :to => :expired
    end

    event :expire do
      transitions :from => :payment_pending, :to => :expired
      # transitions :from => :new, :to => :expired
      transitions :from => :expired, :to => :expired
    end

    event :refund do
      transitions :from => :paid, :to => :refunded
    end

    event :cancel do
      transitions :from => :paid, :to => :canceled
      transitions :from => :payment_pending, :to => :canceled
    end

  end # end aasm
end # end Order
