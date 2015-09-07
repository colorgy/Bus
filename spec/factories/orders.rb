FactoryGirl.define do
  factory :order do
    user { create(:user) }
    price { 2000 }
    schedule { create(:schedule) }
    bill { create(:bill) }
    vehicle { create(:vehicle) }
    seat_no { vehicle.seats.sample.seat_no }
  end

end
