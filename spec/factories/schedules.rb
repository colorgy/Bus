FactoryGirl.define do
  factory :schedule do
    departure_time { DateTime.now + Random.rand(24..500).hours }
    route_id 1
    registration_number { Faker::Address.postcode }
    contact { Faker::PhoneNumber.cell_phone }
    vehicle_id 1
  end

end
