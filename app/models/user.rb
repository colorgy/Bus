class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :trackable, :timeoutable,
         :omniauthable, :omniauth_providers => [:colorgy]

  has_many :cart_items, class_name: 'UserCartItem'
  has_many :orders
  has_many :ordered_schedules, class_name: 'Schedule', through: :orders, source: :user
  has_many :bills

  def self.from_colorgy(auth)
    user = where(:id => auth.info.id).first_or_create! do |new_user|
      new_user.email = auth[:info][:email]
      # new_user.password = Devise.friendly_token[0,20]
    end

    attrs = %i(username name avatar_url cover_photo_url gender fbid uid identity organization_code department_code)

    oauth_params = ActionController::Parameters.new(auth.info)
    user_data = oauth_params.slice(*attrs).permit(*attrs)

    user_data['refreshed_at'] = Time.now
    user_data['core_access_token'] = auth.credentials.token

    user.update!(user_data)

    return user
  end

  def add_to_cart!(schedule: nil, quantity: nil)
    raise "Type Error" unless schedule.is_a?(Schedule) # seat.is_a?(Seat) &&

    cart_item = self.cart_items.find_or_create_by(schedule: schedule)

    if quantity == 0
      cart_item.destroy
    else
      cart_item.update_attributes!(
        quantity: quantity,
        route: schedule.route,
        price: schedule.route.price
      )
    end

  end

  def checkout bill_attrs={}, order_attrs={}
    return { dup_orders: [], orders: [] } if cart_items.blank?

    orders = []
    total_price = 0
    bill = self.bills.build(bill_attrs)

    cart_items.each_with_index do |item, index|

      order = self.orders.build(
        bill: bill,
        price: item.price,
        schedule: item.schedule,
        vehicle: item.schedule.vehicle,
        # seat_no: item.seat.seat_no,
        receiver_name: order_attrs[:receiver_name] && empty_to_nil(order_attrs[:receiver_name]),
        receiver_email: order_attrs[:receiver_email] && empty_to_nil(order_attrs[:receiver_email]),
        receiver_phone: order_attrs[:receiver_phone] && empty_to_nil(order_attrs[:receiver_phone]),
        receiver_identity_number: order_attrs[:receiver_identity_number] && empty_to_nil(order_attrs[:receiver_identity_number])
      )
      total_price += item.price
      orders << order
    end

    bill.price = total_price

    case bill.type
    when 'payment_code'
      bill.amount = total_price + 35
    when 'credit_card'
      bill.amount = total_price * 1.018
    else
      bill.amount = total_price
    end

    { orders: orders, total_price: total_price, bill: bill }
  end

  def checkout! bill_attrs={}, order_attrs={}

    orders = []
    total_price = 0
    bill = nil

    transaction do
      bill = self.bills.build(bill_attrs)

      order_params = {
        bill: bill,
        # seat_no: item.seat.seat_no,
        receiver_name: order_attrs[:receiver_name] && empty_to_nil(order_attrs[:receiver_name]),
        receiver_email: order_attrs[:receiver_email] && empty_to_nil(order_attrs[:receiver_email]),
        receiver_phone: order_attrs[:receiver_phone] && empty_to_nil(order_attrs[:receiver_phone]),
        receiver_identity_number: order_attrs[:receiver_identity_number] && empty_to_nil(order_attrs[:receiver_identity_number])
      }

      cart_items.each do |item, index|
        available_seats = item.schedule.vehicle.seats.select{|st| st.can_order?(user: self, schedule: item.schedule)}.map(&:seat_no)

        raise StandardError if item.quantity > available_seats.count

        random_seats = available_seats.sample(item.quantity)
        random_seats.each do |seat_no|
          order = self.orders.create!(order_params.merge({
            seat_no: seat_no,
            price: item.price,
            schedule: item.schedule,
            vehicle: item.schedule.vehicle,
          }))
          total_price += item.price
          orders << order
        end
      end

      bill.price = total_price

      case bill.type
      when 'payment_code'
        bill.amount = total_price + 35
      when 'credit_card'
        bill.amount = total_price * 1.018
      else
        bill.amount = total_price
      end

      bill.save!
      orders.each{|order| order.bill = bill; order.save!}
      clear_cart!
    end


    { orders: orders, total_price: total_price, bill: bill }
  end


  def clear_cart!
    cart_items.destroy_all
    reload
  end

  private
    def empty_to_nil thing
      thing.empty? ? nil : thing
    end

end
