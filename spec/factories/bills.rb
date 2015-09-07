FactoryGirl.define do
  factory :bill do
    user { create(:user) }
    price 2000
    amount 2000
    invoice_id 1
    type { %w(payment_code credit_card virtual_account test_clickpay test_autopay).sample }
    invoice_type { %w(digital paper code cert love_code uni_num).sample }
    invoice_data "MyText"
    data "MyText"
    state "payment_pending"
    payment_code "MyString"
    paid_at "2015-08-01 10:45:34"
    # user_credits 1
    deadline "2015-08-01 10:45:34"
    receiver_name { Faker::Name.name }
    receiver_email { user.email }
    receiver_phone { Faker::PhoneNumber.cell_phone }
    receiver_identity_number { Faker::Code.ean }
  end

end
