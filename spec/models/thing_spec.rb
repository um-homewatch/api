require "rails_helper"

describe Thing, type: :model do
  describe "attribute validation" do
    subject { build(:thing) }

    it { should validate_presence_of(:type) }

    it { should validate_presence_of(:subtype) }

    it { should validate_presence_of(:payload) }

    it {
      should define_enum_for(:type).
        with(%i[LIGHT LOCK WEATHER THERMOSTAT])
    }
  end

  describe "relation validation" do
    it { should belong_to(:home) }

    it { should delegate_method(:user).to(:home) }
  end
end
