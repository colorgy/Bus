FactoryGirl.define do
  factory :order do
    user { create(:user) }
    price { 2000 }
    schedule { create(:schedule) }
    bill { create(:bill) }
    vehicle { create(:vehicle) }
    seat_no { vehicle.seats.sample.seat_no }
    receiver_name { Faker::Name.name }
    receiver_email { user.email }
    receiver_phone { Faker::PhoneNumber.cell_phone }
    receiver_identity_number { Faker::Code.ean }
  end

end
