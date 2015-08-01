require 'rails_helper'

RSpec.describe Route, type: :model do
  describe "Test Route Relations" do
    it { should have_many(:schedules) }
    it { should belong_to(:admin) }
  end
end
