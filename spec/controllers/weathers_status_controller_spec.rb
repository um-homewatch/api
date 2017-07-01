require "rails_helper"

describe Things::StatusController, type: :controller do
  let(:home) { create(:home) }

  describe "GET #show" do
    it "returns the status of a weather" do
      weather = create(:weather, home: home)
      weather_status = { temperature: 24.5, windSpeed: 11, raining: false, cloudy: true }
      stub_status!(weather, weather_status)

      authenticate(home.user)
      get :show, params: { thing_id: weather.id }

      expect(parsed_response).to eq(weather_status)
    end

    it "should return a not found response" do
      other_home = create(:home)
      weather = create(:weather, home: other_home)

      authenticate(home.user)
      get :show, params: { thing_id: weather.id }

      expect(response).to be_not_found
    end
  end

  describe "PUT #update" do
    it "should return 400" do
      weather = create(:weather, home: home)
      weather_status = { temperature: 24.5, windSpeed: 11, raining: false, cloudy: true }
      stub_send_status!(weather, weather_status, true)

      authenticate(home.user)
      put :update, params: { thing_id: weather.id, status: weather_status }

      expect(response).to be_bad_request
    end

    it "should return a not found response" do
      other_home = create(:home)
      weather = create(:weather, home: other_home)

      authenticate(home.user)
      put :update, params: { thing_id: weather.id }

      expect(response).to be_not_found
    end
  end
end
