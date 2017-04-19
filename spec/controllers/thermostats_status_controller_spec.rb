require "rails_helper"

describe Things::Status::ThermostatController, type: :controller do
  let(:home) { create(:home) }

  describe "GET #show" do
    it "returns the status of a thermostat" do
      thermostat = create(:thermostat, home: home)
      thermostat_status = { targetTemperature: 24.5 }
      stub_status!(thermostat, thermostat_status)

      authenticate(home.user)
      get :show, params: { home_id: home.id, thermostat_id: thermostat.id }

      expect(parsed_response).to eq(thermostat_status)
    end
  end

  describe "PUT #update" do
    it "should update the status of a thermostat" do
      thermostat = create(:thermostat, home: home)
      thermostat_status = { targetTemperature: 20.5 }
      stub_send_status!(thermostat, thermostat_status)

      authenticate(home.user)
      put :update, params: { home_id: home.id, thermostat_id: thermostat.id, status: thermostat_status }

      expect(parsed_response).to eq(thermostat_status)
    end
  end
end
