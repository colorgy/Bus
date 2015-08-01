require 'rails_helper'

RSpec.describe Order, type: :model do
  describe "Order Relation" do
    it { should belong_to(:schedule) }
    it { should belong_to(:bill) }
    it { should belong_to(:user) }
  end
end
