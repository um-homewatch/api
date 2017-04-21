require "rails_helper"

describe Scenario, type: :model do
  describe "attribute validation" do
    subject { build(:home) }

    it { should validate_presence_of(:name) }
  end

  describe "relation validation" do
    it { should have_many(:scenario_things) }
  end
end
