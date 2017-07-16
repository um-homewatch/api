require "rails_helper"

describe Things::DiscoveryController, type: :controller do
  describe "GET #index" do
    it "should return discovered devices" do
      home = create(:home)
      devices = { meme: true }
      stub_discover!(home, "/devices/lights/discover?subtype=hue", devices)

      authenticate(home.user)
      get :index, params: { home_id: home.id, type: "Things::Light", subtype: "hue" }

      expect(parsed_response).to eq(devices)
    end

    it "should return not found response" do
      user = create(:user)
      home = create(:home)

      authenticate(user)
      get :index, params: { home_id: home.id, type: "Things::Light" }

      expect(response).to be_not_found
    end

    it "should return bad request response" do
      home = create(:home)

      authenticate(home.user)
      get :index, params: { home_id: home.id, type: "meme" }

      expect(response).to be_a_bad_request
    end
  end
end
