ActiveAdmin.register Bill do
  menu priority: 119, label: '帳單'

  scope :shown, default: true
  scope :paid
  scope :payment_pending
  scope :unpaid
  scope :expired
  scope :only_deleted
  scope :all

  filter(:id)
  filter(:uuid)
  filter(:user_id)
  filter(:price)
  filter(:amount)
  filter(:state)
  filter(:receiver_name)
  filter(:receiver_email)
  filter(:receiver_phone)
  filter(:receiver_identity_number)
  filter(:payment_code)
  filter(:invoice_type)
  filter(:type)
  filter(:virtual_account)
  filter(:orders_count)
  filter(:deadline)
  filter(:paid_at)
  filter(:created_at)
  filter(:updated_at)
  filter(:mail_sent_at)

  action_item only: [:index] do
    link_to "匯出帳單", bill_export_path
  end

  action_item only: [:index] do
    link_to "匯出發票", invoice_export_path
  end

  controller do
    def scoped_collection
      super.includes :user
    end
  end

  index do
    selectable_column

    id_column
    # column(:uuid)
    column(:user_id) { |bill| a bill.user.name, href: admin_user_path(bill.user) }
    column(:price)
    column(:amount)
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
    column('Mail Sent') { |bill| bill.mail_sent_at.present? ? status_tag('是', :ok) : status_tag('否') }
    column(:quantity) { |bill| bill.orders_count }
    column(:receiver_name)
    column(:receiver_email)
    column(:receiver_phone)
    column(:paid_at)
    column(:deadline)
    column(:deleted) {|bill| bill.deleted? ? status_tag('是', :ok) : status_tag('否') }
    column(:created_at)
    column(:updated_at)

    actions
  end
end
