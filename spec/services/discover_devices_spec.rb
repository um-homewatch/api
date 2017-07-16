require "rails_helper"

describe DiscoverDevices do
  let(:home) { create(:home) }

  def build_uri(home, type)
    service = DiscoverDevices.new(home: home, params: { type: type, port: 1234 })

    service.send(:make_uri)
  end

  describe "#perform" do
    devices = [{ address: "192.168.1.200" }, { address: "192.168.1.150" }]

    it "should return a list of devices" do
      service = DiscoverDevices.new(home: home, params: { type: "Things::Light", subtype: "hue", port: "1234" })
      stub_discover!(home, "/devices/lights/discover?subtype=hue&port=1234", devices)

      devices = service.perform

      expect(devices).to eq(devices)
    end

    it "should set status to true" do
      service = DiscoverDevices.new(home: home, params: { type: "Things::Light", subtype: "hue", port: "1234" })
      stub_discover!(home, "/devices/lights/discover?subtype=hue&port=1234", devices)

      service.perform

      expect(service.status).to be_truthy
    end

    it "should set status to false" do
      service = DiscoverDevices.new(home: home, params: { type: "Things::NotImplemented", subtype: "hue", port: "1234" })
      stub_discover!(home, "/devices/lights/discover?subtype=hue&port=1234", devices)

      service.perform

      expect(service.status).to be_falsy
    end
  end
end
