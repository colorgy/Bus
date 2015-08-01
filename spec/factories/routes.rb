FactoryGirl.define do
  factory :route do
    direction %w(South North).sample
    origin { Faker::Address.city }
    destination { Faker::Address.city }
    price 200
    description { Faker::Lorem.paragraph }
    announcement { Faker::Lorem.paragraph(2) }
    route_map_url { Faker::Avatar.image }
  end

end
