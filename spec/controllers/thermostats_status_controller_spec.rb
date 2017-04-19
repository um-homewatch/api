require "rails_helper"

describe Things::Status::ThermostatController, type: :controller do
  let(:home) { create(:home) }

  describe "GET #show" do
    it "returns the status of a thermostat" do
      thermostat = create(:thermostat, home: home)
      stub_status!(thermostat, targetTemperature: 24.5)

      authenticate(home.user)
      get :show, params: { home_id: home.id, thermostat_id: thermostat.id }

      expect(parsed_response[:targetTemperature]).to be(24.5)
    end
  end

  describe "PUT #update" do
    it "should update the status of a thermostat" do
      thermostat = create(:thermostat, home: home)
      stub_send_status!(thermostat, targetTemperature: 20.5)

      authenticate(home.user)
      put :update, params: { home_id: home.id, thermostat_id: thermostat.id, status: { on: false } }

      expect(parsed_response[:targetTemperature]).to be(20.5)
    end
  end
end
