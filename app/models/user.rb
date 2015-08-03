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

end
