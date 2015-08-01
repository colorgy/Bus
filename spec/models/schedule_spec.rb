require 'rails_helper'

RSpec.describe Schedule, type: :model do
  describe "Schedule Relations" do
     it { should belong_to(:route) }
     it { should belong_to(:vehicle) }
     it { should have_many(:cart_items) }
     it { should have_many(:orders) }
     it { should have_many(:ordered_users).through(:orders) }
   end
end
