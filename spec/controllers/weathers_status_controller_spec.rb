require "rails_helper"

describe Things::Status::WeatherController, type: :controller do
  let(:home) { create(:home) }

  describe "GET #show" do
    it "returns the status of a weather" do
      weather = create(:weather, home: home)
      weather_status = { temperature: 24.5, windSpeed: 11, raining: false, cloudy: true }
      stub_status!(weather, weather_status)

      authenticate(home.user)
      get :show, params: { home_id: home.id, weather_id: weather.id }

      expect(parsed_response).to eq(weather_status)
    end
  end
end
