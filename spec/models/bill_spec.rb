require 'rails_helper'

RSpec.describe Bill, type: :model do
  describe "Bill Relations" do
    it { should have_many(:orders) }
    it { should belong_to(:user) }
  end
end
