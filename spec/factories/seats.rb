FactoryGirl.define do
  factory :seat do
    vehicle_id { create(:vehicle) }
    priority { Random.rand(1..40) }
    seat_no { "#{(65 + rand(26)).chr}#{Random.rand(1..40)}" }
    row_no { Random.rand(1..15) }
  end

end
