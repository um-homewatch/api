require "rails_helper"

describe Things::ThermostatsController, type: :controller do
  let(:home) { create(:home) }

  context "POST #create" do
    it "creates a user thermostat" do
      thermostat_params = attributes_for(:thermostat, home: home)

      authenticate(home.user)

      expect do
        post :create, params: { home_id: home.id, thing: thermostat_params }
      end.to change { home.thermostats.count }.by(1)
    end

    it "returns the created resource" do
      thermostat_params = attributes_for(:thermostat)

      authenticate(home.user)
      post :create, params: { home_id: home.id, thing: thermostat_params }

      expect(parsed_response[:subtype]).to eq(thermostat_params[:subtype])
      expect(parsed_response[:connection_info]).to eq(thermostat_params[:connection_info])
    end

    it "returns a not found status code" do
      other_home = create(:home)
      thermostat_params = attributes_for(:thermostat)

      authenticate(home.user)
      post :create, params: { home_id: other_home.id, thing: thermostat_params }

      expect(response).to have_http_status(:not_found)
    end
  end
end
