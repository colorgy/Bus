FactoryGirl.define do
  factory :bill do
    price 1
    amount 1
    invoice_id 1
    invoice_type "MyString"
    invoice_data "MyText"
    data "MyText"
    state "MyString"
    payment_code "MyString"
    paid_at "2015-08-01 10:45:34"
    user_credits 1
    deadline "2015-08-01 10:45:34"
  end

end
