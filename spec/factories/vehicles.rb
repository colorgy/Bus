FactoryGirl.define do
  factory :vehicle do
    name { Faker::Name.name }
    capacity { [35, 50].sample }
    registration_number { Faker::Address.postcode }
    description { Faker::Lorem.paragraph }
    # seat_info { Faker::Lorem.paragraph }
  end
end
