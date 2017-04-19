require "rails_helper"

describe Things::DiscoveryController, type: :controller do
  describe "GET #index" do
    it "should return discovered devices" do
      home = create(:home)
      devices = { meme: true }
      stub_discover!(home, "/lights/discover", devices)

      authenticate(home.user)
      get :index, params: { home_id: home.id, type: "light" }

      expect(parsed_response).to eq(devices)
    end

    it "should return bad request response" do
      home = create(:home)

      authenticate(home.user)
      get :index, params: { home_id: home.id, type: "meme" }

      expect(response).to be_a_bad_request
    end
  end
end
