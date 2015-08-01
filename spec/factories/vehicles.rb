FactoryGirl.define do
  factory :vehicle do
    capacity { [35, 50].sample }
    description "MyText"
    seat_info "MyText"
  end
end
