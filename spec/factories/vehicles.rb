FactoryGirl.define do
  factory :vehicle do
    capacity { [35, 50].sample }
    description { Faker::Lorem.paragraph }
    seat_info { Faker::Lorem.paragraph }
  end
end
