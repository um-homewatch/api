require "rails_helper"

describe Thing, type: :model do
  describe "attribute validation" do
    subject { build(:thing) }

    it { should validate_presence_of(:name) }

    it { should validate_presence_of(:type) }

    it { should validate_presence_of(:subtype) }

    it { should validate_presence_of(:connection_info) }
  end

  describe "relation validation" do
    it { should belong_to(:home) }

    it { should delegate_method(:user).to(:home) }
  end

  describe "comparators validators" do
    it "sould return true for equals" do
      thing = create(:weather)
      thing_status = { temperature: 24.5, windSpeed: 11, raining: false, cloudy: true }
      stub_status!(thing, thing_status)

      value = thing.equals([:temperature, :raining], temperature: 24.5, raining: false)

      expect(value).to be_truthy
    end

    it "sould return false for equals" do
      thing = create(:weather)
      thing_status = { temperature: 24.5, windSpeed: 11, raining: false, cloudy: true }
      stub_status!(thing, thing_status)

      value = thing.equals([:temperature, :raining], temperature: 34.5, raining: true)

      expect(value).to be_falsy
    end

    it "sould return true for greater" do
      thing = create(:weather)
      thing_status = { temperature: 24.5, windSpeed: 11, raining: false, cloudy: true }
      stub_status!(thing, thing_status)

      value = thing.greater([:temperature, :windSpeed], temperature: 10, windSpeed: 5)

      expect(value).to be_truthy
    end

    it "sould return false for greater" do
      thing = create(:weather)
      thing_status = { temperature: 24.5, windSpeed: 11, raining: false, cloudy: true }
      stub_status!(thing, thing_status)

      value = thing.greater([:temperature, :raining], temperature: 34.5, windSpeed: 2)

      expect(value).to be_falsy
    end

    it "should return true for less" do
      thing = create(:weather)
      thing_status = { temperature: 24.5, windSpeed: 11, raining: false, cloudy: true }
      stub_status!(thing, thing_status)

      value = thing.less([:temperature, :windSpeed], temperature: 30, windSpeed: 15)

      expect(value).to be_truthy
    end

    it "should return false for less" do
      thing = create(:weather)
      thing_status = { temperature: 24.5, windSpeed: 11, raining: false, cloudy: true }
      stub_status!(thing, thing_status)

      value = thing.less([:temperature, :raining], temperature: 5, windSpeed: 2)

      expect(value).to be_falsy
    end
  end
end
