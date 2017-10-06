require "rails_helper"

describe Home, type: :model do
  describe "attribute validation" do
    subject { build(:home) }

    it { should validate_presence_of(:name) }

    it { should validate_presence_of(:location) }

    it { should validate_presence_of(:ip_address) }
  end

  describe "relation validation" do
    it { should belong_to(:user) }

    it { should have_many(:things) }

    it { should have_many(:lights) }

    it { should have_many(:locks) }

    it { should have_many(:thermostats) }

    it { should have_many(:weathers) }

    it { should have_many(:scenarios) }
  end
end
