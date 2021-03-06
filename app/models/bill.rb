class Bill < ActiveRecord::Base
  include AASM

  acts_as_paranoid
  has_paper_trail

  belongs_to :user
  has_many :orders, dependent: :destroy

  # All allowed payment types
  TYPES = %w(payment_code credit_card virtual_account test_clickpay test_autopay)
  # All allowed invoice types
  INVOICE_TYPES = %w(digital paper code cert love_code uni_num)
  # Deadline adjustment of the bill, we will not mark the bill as expired
  # (marking as expired also means stop tracking its status) after the bill
  # deadline haven't been overdue for more than this time.
  PAYMENT_DEADLINE_ADJ = 3.days

  self.inheritance_column = :_type_disabled

  scope :shown, -> { where(deleted_at: nil) }
  scope :paid, -> { where(state: 'paid') }
  scope :payment_pending, -> { where(state: 'payment_pending') }
  scope :unpaid, -> { where.not(state: 'paid') }
  scope :expired, -> { where(state: 'expired') }

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

  after_initialize :init_uuid, :set_deadline # , :expire_if_deadline_passed
  before_create :get_payment_info

  # aasm borrow from Colorg Book
  aasm column: :state do
    state :payment_pending, initial: true
    state :paid
    state :expired
    state :canceled # 整筆帳單取消
    state :refunded

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

    event :refund do
      transitions :from => :paid, :to => :refunded do
        after do
          orders.each(&:refund!)
        end
      end
    end

    event :cancel do
      transitions :from => :paid, :to => :canceled do
        after do
          orders.each(&:cancel!)
        end
      end

      transitions :from => :payment_pending, :to => :canceled do
        after do
          orders.each(&:cancel!)
        end
      end
    end

  end # end aasm

  class << self
    def allowed_types
      return @allowed_types if @allowed_types.present?
      @allowed_types = (ENV['ALLOWED_BILL_TYPES'].split(',') & TYPES)
    end

    def type_selections
      @bill_type_selections ||= allowed_types.map { |bt| [I18n.t(bt, scope: :bill_types), bt] }
    end

    def type_label(bt)
      I18n.t(bt, scope: :bill_types)
    end

    def invoice_type_label(bit)
      I18n.t(bit, scope: :invoice_types)
    end
  end

  # Get the payment information from 3rd services to make this bill payable
  def get_payment_info
    raise 'bill type not allowed' unless Bill.allowed_types.include?(type)
    return if Rails.env.test?

    self.deadline = 28.days.from_now if deadline > 28.days.from_now

    case type
    when 'payment_code'
      self.payment_code = NewebPayService.get_payment_code(uuid, amount, payname: user.name, duedate: deadline)

    when 'virtual_account'
      self.virtual_account = SinoPacService.get_virtual_account(uuid, amount, payname: user.name, duedate: deadline)
    end
  end

  def credit_card_pay_link(text = '按此進行信用卡付款')
    SinoPacService.credit_card_pay_link(uuid, amount, text: text) if Time.now < deadline
  end

  def pay_if_paid!
    case type
    when 'payment_code'
      pay! if NewebPayService.reget_payment_code(uuid, amount) == true

    when 'virtual_account'
      pay! if SinoPacService.virtual_account_paid?(uuid)

    when 'credit_card'
      pay! if SinoPacService.credit_card_paid?(uuid)
    end
  end

  def expire_if_deadline_passed
    self.expire! if may_expire? && deadline.present? && Time.now > deadline
  end

  # 偷懶用
  def regenearte_payment_code
    if self.type == 'payment_code' && (self.state == 'payment_pending' || self.state == 'expired')
      self.uuid = "ba#{SecureRandom.uuid[2..28]}"
      self.deadline = Time.now + PAYMENT_DEADLINE_ADJ

      orders.each { |ord| ord.state = "payment_pending"; ord.save! }

      self.save!
      reload

      get_payment_info

      self.save!

      return self.payment_code
    end
    nil
  end

  def check_deadline orders
    # early deadline first
    dep_time = orders.map{|ord| ord.schedule.departure_time }.min
    if dep_time &&  self.deadline > dep_time
      self.deadline = Time.new(dep_time.year, dep_time.month, dep_time.day, 19, 59, 59, "+08:00") - 1.day
    end
  end

  private

  # Initialize the uuid on creation
  def init_uuid
    return unless self.uuid.blank?
    self.uuid = "ba#{SecureRandom.uuid[2..28]}"
  end

  def set_deadline
    self.deadline ||= Time.now + PAYMENT_DEADLINE_ADJ if self.new_record?
  end
end
