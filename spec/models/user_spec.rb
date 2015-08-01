require 'rails_helper'

RSpec.describe User, type: :model do
  describe "User Relations" do
    it { should have_many(:bills) }
    it { should have_many(:orders) }
    it { should have_many(:ordered_schedules).through(:orders) }
    it { should have_many(:cart_items) }
  end
end
