require "rails_helper"

describe Thing, type: :model do
  describe "attribute validation" do
    subject { build(:thing) }

    it { should validate_presence_of(:type) }

    it { should validate_presence_of(:subtype) }

    it { should validate_presence_of(:connection_info) }
  end

  describe "relation validation" do
    it { should belong_to(:home) }

    it { should delegate_method(:user).to(:home) }
  end
end
