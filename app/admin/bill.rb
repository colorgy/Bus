ActiveAdmin.register Bill do
  menu priority: 119, label: '帳單'

  scope :all, default: true
  scope :paid
  scope :payment_pending
  scope :unpaid
  scope :expired

  controller do
    def scoped_collection
      super.includes :user
    end
  end

  index do
    selectable_column
    column(:id)
    column(:uuid)
    column(:user_id) { |bill| a bill.user.name, href: admin_user_path(bill.user) }
    column(:price)
    column(:amount)
    column(:invoice_type)
    column(:type)
    column(:state) do |bill|
      tag = nil
      case bill.state
      when "paid"
        tag = :ok
      when "payment_pending"
        tag = :warning
      end
      tag.nil? ? status_tag(bill.state) : status_tag(bill.state, tag)
    end
    column(:quantity) { |bill| bill.orders_count }
    column(:payment_code)
    column(:virtual_account)
    column(:paid_at)
    column(:deadline)
    column(:created_at)
    column(:updated_at)
    actions
  end
end
