require "rails_helper"

describe DiscoverDevices do
  let(:home) { create(:home) }

  def build_uri(home, type)
    service = DiscoverDevices.new(home: home, type: type)

    service.send(:make_uri)
  end

  describe "type validation" do
    it "should build uri with the type LIGHT" do
      expect(build_uri(home, "light")).to be_truthy
    end

    it "should build uri with the type LOCK" do
      expect(build_uri(home, "lock")).to be_truthy
    end

    it "should build a uri with the type THERMOSTAT" do
      expect(build_uri(home, "thermostat")).to be_truthy
    end

    it "should build a uri with the type WEATHER" do
      expect(build_uri(home, "weather")).to be_truthy
    end

    it "should fail with a unknown type" do
      expect(build_uri(home, "meme")).to be_falsey
    end
  end

  describe "#perform" do
    devices = [{ address: "192.168.1.200" }, { address: "192.168.1.150" }]

    it "should return a list of devices" do
      service = DiscoverDevices.new(home: home, type: "light")
      stub_discover!(home, "/lights/discover", devices)

      devices = service.perform

      expect(devices).to eq(devices)
    end
  end
end
