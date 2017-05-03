require "rails_helper"

describe Things::StatusController, type: :controller do
  let(:home) { create(:home) }

  describe "GET #show" do
    it "returns the status of a thermostat" do
      thermostat = create(:thermostat, home: home)
      thermostat_status = { targetTemperature: 24.5 }
      stub_status!(thermostat, thermostat_status)

      authenticate(home.user)
      get :show, params: { thing_id: thermostat.id }

      expect(parsed_response).to eq(thermostat_status)
    end

    it "should return a not found response" do
      other_home = create(:home)
      thermostat = create(:thermostat, home: other_home)

      authenticate(home.user)
      get :show, params: { thing_id: thermostat.id }

      expect(response).to be_not_found
    end
  end

  describe "PUT #update" do
    it "should update the status of a thermostat" do
      thermostat = create(:thermostat, home: home)
      thermostat_status = { targetTemperature: 20.5 }
      stub_send_status!(thermostat, thermostat_status, true)

      authenticate(home.user)
      put :update, params: { thing_id: thermostat.id, status: thermostat_status }

      expect(parsed_response).to eq(thermostat_status)
    end

    it "should return a not found response" do
      other_home = create(:home)
      thermostat = create(:thermostat, home: other_home)

      authenticate(home.user)
      put :update, params: { thing_id: thermostat.id }

      expect(response).to be_not_found
    end
  end
end
