class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :trackable, :timeoutable,
         :omniauthable, :omniauth_providers => [:colorgy]

  has_many :cart_items, class_name: 'UserCartItem', dependent: :destroy
  has_many :orders
  has_many :ordered_schedules, class_name: 'Schedule', through: :orders, source: :user
  has_many :bills
  has_many :route_requests

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

    cart_item = self.cart_items.where(schedule: schedule).first_or_initialize

    cart_item.quantity = (cart_item.id.nil?) ? quantity : (cart_item.quantity.to_i + quantity)
    cart_item.route = schedule.route
    cart_item.price = schedule.route.price

    cart_item.save!
    reload
  end

  def checkout bill_attrs={}
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
      )
      total_price += item.price
      orders << order
    end

    bill.price = total_price

    case bill.type
    when 'payment_code'
      bill.amount = total_price + 15
    when 'credit_card'
      bill.amount = total_price * 1.018
    else
      bill.amount = total_price
    end

    { orders: orders, total_price: total_price, bill: bill }
  end

  def checkout! bill_attrs={}

    orders = []
    total_price = 0
    bill = nil

    transaction do
      bill = self.bills.build(bill_attrs)

      cart_items.each do |item, index|
        available_seats_no = item.schedule.vehicle.seats.select{|st| st.can_order?(user: self, schedule: item.schedule)}.map(&:seat_no)

        raise StandardError if item.quantity > available_seats_no.count

        random_seats_no = available_seats_no.sample(item.quantity)
        random_seats_no.each do |seat_no|
          order = self.orders.create!(
            bill: bill,
            seat_no: seat_no,
            price: item.price,
            schedule: item.schedule,
            vehicle: item.schedule.vehicle,
          )
          total_price += item.price
          orders << order
        end
      end

      bill.price = total_price

      case bill.type
      when 'payment_code'
        bill.amount = total_price + 15
      when 'credit_card'
        bill.amount = total_price * 1.018
      else
        bill.amount = total_price
      end

      # setup bill deadlin
      bill.check_deadline(orders)
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
