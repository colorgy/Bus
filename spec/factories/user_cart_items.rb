FactoryGirl.define do
  factory :user_cart_item do
    user { create(:user) }
    schedule { create(:schedule) }
    route { schedule.route }
    seat { create(:seat, vehicle: schedule.vehicle) }
    price { route.price }
  end

end
