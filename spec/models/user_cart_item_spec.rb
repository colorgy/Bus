require 'rails_helper'

RSpec.describe UserCartItem, type: :model do
  describe "UserCartItem Relations" do
    it { should belong_to(:user) }
    it { should belong_to(:schedule) }
    it { should belong_to(:seat) }
  end
end
