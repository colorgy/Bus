require 'rails_helper'

RSpec.describe Seat, type: :model do
  it { should belong_to(:vehicle) }
  it { should have_many(:orders) }
  it { should have_many(:cart_items) }

  describe "#can_order?" do

  end
end
