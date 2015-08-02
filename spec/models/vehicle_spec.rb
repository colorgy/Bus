require 'rails_helper'

RSpec.describe Vehicle, type: :model do
  describe "Vehicle Relations" do
    it { should have_many(:schedules) }
    it { should have_many(:orders) }
    it { should have_many(:seats) }
  end
end
