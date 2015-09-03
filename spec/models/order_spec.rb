require 'rails_helper'

RSpec.describe Order, type: :model do
  describe "Order Relation" do
    it { should belong_to(:schedule) }
    it { should belong_to(:bill) }
    it { should belong_to(:user) }
    it { should belong_to(:vehicle) }
    it { should belong_to(:seat) }
  end

  describe "validate uniqueness order" do
    let(:bill) { create(:bill) }

    it "can't create order with two same seats" do
      order1 = create(:order, bill: bill, state: "payment_pending")
      order2 = build(:order, bill: bill, schedule: order1.schedule, vehicle: order1.vehicle, user: order1.user, state: "payment_pending")

      order2.seat_no = order1.seat_no
      expect{ order2.save! }.to raise_error(ActiveRecord::RecordInvalid)

      order1.pay!
      expect{ order2.save! }.to raise_error(ActiveRecord::RecordInvalid)

      order1.cancel!
      order2.save!

      expect{ order2.refund! }.to raise_error(AASM::InvalidTransition)
      order2.pay!
      order2.refund!

      order1.state = "paid"
      order1.save!
    end
  end
end
