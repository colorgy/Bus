ActiveAdmin.register Order do
  menu priority: 120, label: '訂單'

  scope :shown, default: true
  scope :paid
  scope :canceled
  scope :refunded
  scope :expired
  scope :only_deleted
  scope :all

  filter(:id)
  filter(:user_id)
  filter(:price)
  filter(:schedule_id)
  filter(:bill_id)
  filter(:vehicle_id)
  filter(:seat_no)
  filter(:state)
  filter(:created_at)
  filter(:updated_at)
  filter(:deleted_at)

  controller do
    def scoped_collection
      super.includes({schedule: {route: :parent} }, :bill)
    end
  end

  index do
    selectable_column

    id_column
    column(:user)
    column(:price)

    column('Route', sortable: 'routes') do |order|
      if order.schedule.present? && order.schedule.route.present?
        a order.schedule.route.short_name, href: admin_route_path(order.schedule.route.parent)
      else
        "null route"
      end
    end

    column('Schedule') {|order| order.schedule.present? ? order.schedule.formatted_departure_time : "null schedule" }
    column(:bill) { |order| a order.bill_id, href: admin_bill_path(order.bill_id) }
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
    column(:deleted) {|order| order.deleted? ? status_tag('是', :ok) : status_tag('否') }
    column(:created_at)
    column(:updated_at)
    actions
  end

end
