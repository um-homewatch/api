require "rails_helper"

describe Things::ThermostatsController, type: :controller do
  let(:home) { create(:home) }

  describe "GET #index" do
    it "returns the thermostats of a home" do
      thermostats = create_list(:thermostat, 3, home: home)
      json = serialize_to_json(thermostats)

      authenticate(home.user)
      get :index, params: { home_id: home.id }

      expect(response.body).to eq(json)
    end

    it "returns a not found status code" do
      other_home = create(:home)
      create_list(:thermostat, 3, home: other_home)

      authenticate(home.user)
      get :index, params: { home_id: other_home.id }

      expect(response).to have_http_status(:not_found)
    end
  end

  describe "GET #show" do
    it "returns a thermostat from a home" do
      thermostat = create(:thermostat, home: home)
      json = serialize_to_json(thermostat)

      authenticate(home.user)
      get :show, params: { home_id: home.id, id: thermostat.id }

      expect(response.body).to eq(json)
    end

    it "returns a not found status code" do
      other_home = create(:home)
      thermostat = create(:thermostat, home: other_home)

      authenticate(home.user)
      get :index, params: { home_id: other_home.id, thermostat_id: thermostat.id }

      expect(response).to have_http_status(:not_found)
    end
  end

  context "POST #create" do
    it "creates a user thermostat" do
      thermostat_params = attributes_for(:thermostat, home: home)

      authenticate(home.user)

      expect do
        post :create, params: { home_id: home.id, thermostat: thermostat_params }
      end.to change { home.thermostats.count }.by(1)
    end

    it "returns the created resource" do
      thermostat_params = attributes_for(:thermostat)

      authenticate(home.user)
      post :create, params: { home_id: home.id, thermostat: thermostat_params }

      expect(parsed_response[:subtype]).to eq(thermostat_params[:subtype])
      expect(parsed_response[:connection_info]).to eq(thermostat_params[:connection_info])
    end

    it "returns a not found status code" do
      other_home = create(:home)
      thermostat_params = attributes_for(:thermostat)

      authenticate(home.user)
      post :create, params: { home_id: other_home.id, thermostat: thermostat_params }

      expect(response).to have_http_status(:not_found)
    end
  end

  describe "PUT #update" do
    it "updates the info of a thermostat" do
      thermostat = create(:thermostat, home: home)
      thermostat_params = attributes_for(:thermostat)

      authenticate(home.user)
      put :update, params: { home_id: home.id, id: thermostat.id, thermostat: thermostat_params }
      thermostat.reload

      expect(thermostat.subtype).to eq(thermostat_params[:subtype])
      expect(thermostat.connection_info).to eq(thermostat_params[:connection_info])
    end

    it "returns a not found status code" do
      other_home = create(:home)
      thermostat = create(:thermostat, home: other_home)
      thermostat_params = attributes_for(:thermostat)

      authenticate(home.user)
      put :update, params: { home_id: other_home.id, id: thermostat.id, thermostat: thermostat_params }

      expect(response).to have_http_status(:not_found)
    end
  end

  describe "DELETE #destroy" do
    it "destroys the requested thermostat" do
      thermostat = create(:thermostat, home: home)

      authenticate(home.user)

      expect do
        delete :destroy, params: { home_id: home.id, id: thermostat.id }
      end.to change { home.thermostats.count }.by(-1)
    end

    it "returns a not found status code" do
      other_home = create(:home)
      thermostat = create(:thermostat, home: other_home)

      authenticate(home.user)
      delete :destroy, params: { home_id: other_home.id, id: thermostat.id }

      expect(response).to have_http_status(:not_found)
    end
  end
end
