require "rails_helper"

describe DiscoverDevices do
  let(:home) { create(:home) }

  def build_uri(home, type)
    service = DiscoverDevices.new(home: home, params: { type: type })

    service.send(:make_uri)
  end

  describe "type validation" do
    it "should build uri with the type LIGHT" do
      expect(build_uri(home, "Things::Light")).to be_truthy
    end

    it "should build uri with the type LOCK" do
      expect(build_uri(home, "Things::Lock")).to be_truthy
    end

    it "should build a uri with the type THERMOSTAT" do
      expect(build_uri(home, "Things::Thermostat")).to be_truthy
    end

    it "should build a uri with the type WEATHER" do
      expect(build_uri(home, "Things::Weather")).to be_truthy
    end

    it "should fail with a unknown type" do
      expect(build_uri(home, "meme")).to be_falsey
    end
  end

  describe "#perform" do
    devices = [{ address: "192.168.1.200" }, { address: "192.168.1.150" }]

    it "should return a list of devices" do
      service = DiscoverDevices.new(home: home, params: { type: "Things::Light", subtype: "hue" })
      stub_discover!(home, "/lights/discover?type=Things::Light&subtype=hue", devices)

      devices = service.perform

      expect(devices).to eq(devices)
    end
  end
end
