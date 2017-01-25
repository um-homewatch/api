require "rails_helper"

describe User, type: :model do
  describe "attribute validation" do
    subject { build(:user) }

    it { should validate_presence_of(:name) }

    it { should validate_presence_of(:email) }

    it { should validate_uniqueness_of(:email) }
  end
end
