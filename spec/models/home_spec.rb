require "rails_helper"

describe Home, type: :model do
  describe "attribute validation" do
    subject { build(:home) }

    it { should validate_presence_of(:name) }

    it { should validate_presence_of(:location) }

    it { should validate_presence_of(:ip_address) }

    it { should validate_uniqueness_of(:ip_address) }
  end

  describe "relation validation" do
    it { should belong_to(:user) }

    it { should have_many(:things) }
  end
end
