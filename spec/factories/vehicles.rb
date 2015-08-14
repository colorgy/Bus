FactoryGirl.define do
  factory :vehicle do
    name { Faker::Name.name }
    capacity { [35, 50].sample }
    registration_number { Faker::Address.postcode }
    description { Faker::Lorem.paragraph }
    seat_info_string do
      '{
        "seating": [
          [ "1",  "2", null, null],
          [ "5",  "6", null,  "3"],
          [ "8",  "9", null,  "7"],
          [ "11", "12", null, "10"],
          ["15", "16", null, "13"],
          ["18", "19", null, "17"],
          ["20", "21", null, "25"],
          ["22", "23", null, "28"],
          ["26", "27", null, "29"],
          ["30", "31", null, "32"],
          ["33", "35", "36", "37"]
        ]
      }'
    end
  end
end
