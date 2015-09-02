ActiveAdmin.register Order do
  menu priority: 120, label: '訂單'

  scope :all, default: true
  scope :paid
  scope :canceled
  scope :refunded
  scope :expired

  controller do
    def scoped_collection
      super.includes({schedule: {route: :parent} }, :bill)
    end
  end

  index do
    selectable_column
    column(:id)
    column(:user)
    column(:price)

    column('Route') { |order| a order.schedule.route.short_name, href: admin_route_path(order.schedule.route.parent) }

    column('Schedule') {|order| order.schedule.formatted_departure_time }
    column(:bill) { |order| a order.bill.id, href: admin_bill_path(order.bill) }
    column(:seat_no)
    column(:state) do |order|
      tag = nil
      case order.state
      when "paid"
        tag = :ok
      when "payment_pending"
        tag = :warning
      end
      tag.nil? ? status_tag(order.state) : status_tag(order.state, tag)
    end
    column(:created_at)
    column(:updated_at)
  end

end
