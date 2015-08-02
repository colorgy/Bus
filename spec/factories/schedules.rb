FactoryGirl.define do
  factory :schedule do
    departure_time { DateTime.now + Random.rand(24..500).hours }
    route { create(:route) }
    contact { Faker::PhoneNumber.cell_phone }
    vehicle { create(:vehicle) }
  end

end
