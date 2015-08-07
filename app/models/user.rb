class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :omniauthable, :omniauth_providers => [:colorgy]

  has_many :cart_items, class_name: 'UserCartItem'
  has_many :orders
  has_many :ordered_schedules, class_name: 'Schedule', through: :orders, source: :user
  has_many :bills

  def self.from_colorgy(auth)
    user = where(:id => auth.info.id).first_or_create! do |new_user|
      new_user.email = auth[:info][:email]
      new_user.password = Devise.friendly_token[0,20]
    end

    attrs = %i(username name avatar_url cover_photo_url gender fbid uid identity organization_code department_code)

    oauth_params = ActionController::Parameters.new(auth.info)
    user_data = oauth_params.slice(*attrs).permit(*attrs)

    user_data['refreshed_at'] = Time.now
    user_data['core_access_token'] = auth.credentials.token

    user.update!(user_data)

    return user
  end

  def add_to_cart!(schedule: nil, seat: nil)
    raise "Type Error" unless seat.is_a?(Seat) && schedule.is_a?(Schedule)
    cart_items.create!(
      seat: seat,
      schedule: schedule,
      route: schedule.route,
      price: schedule.route.price
    )
  end

  def checkout bill_attrs={}, order_attrs={}
    return { dup_orders: [], orders: [] } if cart_items.blank?

    dup_orders = []
    orders = []
    total_price = 0
    bill = self.bills.build(bill_attrs)

    cart_items.each_with_index do |item, index|

      dup_ord = Order.find_by(schedule: item.schedule, seat: item.seat)
      # find duplicate order
      if dup_ord
        dup_orders << dup_ord
      else
        order = self.orders.build(
          bill: bill,
          price: item.price,
          schedule: item.schedule,
          vehicle: item.seat.vehicle,
          seat: item.seat,
          receiver_name: order_attrs[:receiver_name] && empty_to_nil(order_attrs[:receiver_name][index]),
          receiver_email: order_attrs[:receiver_email] && empty_to_nil(order_attrs[:receiver_email][index]),
          receiver_phone: order_attrs[:receiver_phone] && empty_to_nil(order_attrs[:receiver_phone][index]),
          receiver_identity_number: order_attrs[:receiver_identity_number] && empty_to_nil(order_attrs[:receiver_identity_number][index])
        )
        total_price += item.price
        orders << order
      end
    end

    bill.price = total_price
    bill.amount = total_price # 先這樣

    data = { dup_orders: dup_orders, orders: orders, total_price: total_price, bill: bill }

    data
  end

  def checkout! bill_attrs={}, order_attrs={}
    checkouts = checkout(bill_attrs, order_attrs)
    return checkouts if checkouts[:bill].blank?

    transaction do
      checkouts[:bill].save!
      checkouts[:orders].each(&:save!)
      clear_cart!
    end

    checkouts
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
