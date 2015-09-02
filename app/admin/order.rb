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

    column('Route') do |order|
      if order.schedule && order.schedule.route
        a order.schedule.route.short_name, href: admin_route_path(order.schedule.route.parent)
      else
        "null route"
      end
    end

    column('Schedule') {|order| order.schedule.present? ? order.schedule.formatted_departure_time : "null schedule" }
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
    actions
  end

end
