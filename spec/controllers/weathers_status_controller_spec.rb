require "rails_helper"

describe Things::Status::WeatherController, type: :controller do
  let(:home) { create(:home) }

  describe "GET #show" do
    it "returns the status of a weather" do
      weather = create(:weather, home: home)
      stub_status!(weather, temperature: 24.5, windSpeed: 11, raining: false, cloudy: true)

      authenticate(home.user)
      get :show, params: { home_id: home.id, weather_id: weather.id }

      expect(parsed_response[:temperature]).to be(24.5)
      expect(parsed_response[:windSpeed]).to be(11)
      expect(parsed_response[:raining]).to be_falsey
      expect(parsed_response[:cloudy]).to be_truthy
    end
  end
end
