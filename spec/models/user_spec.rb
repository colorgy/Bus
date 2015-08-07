require 'rails_helper'

RSpec.describe User, type: :model do
  let(:user) { FactoryGirl.create(:user) }
  let(:user2) { FactoryGirl.create(:user) }
  let(:schedule) { FactoryGirl.create(:schedule) }

  describe "User Relations" do
    it { should have_many(:bills) }
    it { should have_many(:orders) }
    it { should have_many(:ordered_schedules).through(:orders) }
    it { should have_many(:cart_items) }
  end

  describe "#add_to_cart!" do
    it "add an seat to cart" do
      seat = FactoryGirl.create(:seat, vehicle: schedule.vehicle)
      user.add_to_cart!(schedule: schedule, seat: seat)

      expect(user.cart_items.first.schedule_id).to eq(schedule.id)
      expect(user.cart_items.first.user_id).to eq(user.id)
      expect(user.cart_items.first.route).to eq(schedule.route)
      expect(user.cart_items.first.seat).to eq(seat)
      expect(user.cart_items_count).to eq(1)
    end

    it "can't add_to_cart if same seats add twice" do
      seat = FactoryGirl.create(:seat, vehicle: schedule.vehicle)
      user.add_to_cart!(schedule: schedule, seat: seat)

      expect{ user.add_to_cart!(schedule: schedule, seat: seat) }.to raise_error(ActiveRecord::RecordNotUnique)
    end

    it "can add to cart if two user add same seat to cart" do
      seat = FactoryGirl.create(:seat, vehicle: schedule.vehicle)

      user.add_to_cart!(schedule: schedule, seat: seat)
      expect { user2.add_to_cart!(schedule: schedule, seat: seat) }.not_to raise_error
    end

    it "would also check type" do
      seat = FactoryGirl.create(:seat, vehicle: schedule.vehicle)
      expect { user.add_to_cart!(schedule: seat, seat: schedule) }.to raise_error "Type Error"
    end

  end

  describe "#checkout" do
    it "can't checkout when seat conflict" do
      seat = FactoryGirl.create(:seat, vehicle: schedule.vehicle)
      user.add_to_cart!(schedule: schedule, seat: seat)

    end
  end

  describe "#checkout!" do

  end
end
