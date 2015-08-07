class Bill < ActiveRecord::Base
  include AASM
  acts_as_paranoid

  belongs_to :user
  has_many :orders

  # All allowed payment types
  TYPES = %w(payment_code credit_card virtual_account test_clickpay test_autopay)
  # All allowed invoice types
  INVOICE_TYPES = %w(digital paper code cert love_code uni_num)
  # Deadline adjustment of the bill, we will not mark the bill as expired
  # (marking as expired also means stop tracking its status) after the bill
  # deadline haven't been overdue for more than this time.
  PAYMENT_DEADLINE_ADJ = 3.days

  self.inheritance_column = :_type_disabled

  scope :paid, -> { where(state: 'paid') }
  scope :payment_pending, -> { where(state: 'payment_pending') }
  scope :unpaid, -> { where.not(state: 'paid') }

  store :data, accessors: [:invoice_code, :invoice_love_code, :invoice_uni_num, :invoice_cert]

  validates :type, presence: true,
                   inclusion: { in: TYPES }
  validates :invoice_type, presence: true,
                           inclusion: { in: INVOICE_TYPES }
  validates :uuid, presence: true
  validates :user, presence: true
  validates :type, presence: true
  validates :price, presence: true
  validates :amount, presence: true
  validates :state, presence: true
  validates :deadline, presence: true

  after_initialize :init_uuid, :set_deadline #, :expire_if_deadline_passed

  # aasm borrow from Colorg Book
  aasm column: :state do
    state :payment_pending, initial: true
    state :paid
    state :expired

    event :pay do
      transitions :from => :payment_pending, :to => :paid do
        after do
          self.paid_at = Time.now
          orders.each(&:pay!)
        end
      end
    end

    event :expire do
      transitions :from => :payment_pending, :to => :expired do
        after do
          orders.each(&:expire!)
        end
      end
    end
  end # end aasm

  private

    # Initialize the uuid on creation
    def init_uuid
      return unless self.uuid.blank?
      self.uuid = "bo#{SecureRandom.uuid[2..28]}"
    end

    def set_deadline
      self.deadline = Time.now + PAYMENT_DEADLINE_ADJ
    end

end
