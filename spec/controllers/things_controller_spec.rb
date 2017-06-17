require "rails_helper"

describe ThingsController, type: :controller do
  let(:home) { create(:home) }

  describe "GET #index" do
    it "returns the lights of a home" do
      lights = create_list(:light, 3, home: home)
      json = serialize_to_json(lights)

      authenticate(home.user)
      get :index, params: { home_id: home.id }

      expect(response.body).to eq(json)
    end

    it "returns a not found status code" do
      other_home = create(:home)
      create_list(:light, 3, home: other_home)

      authenticate(home.user)
      get :index, params: { home_id: other_home.id }

      expect(response).to have_http_status(:not_found)
    end
  end

  describe "GET #show" do
    it "returns a light from a home" do
      light = create(:light, home: home)
      json = serialize_to_json(light)

      authenticate(home.user)
      get :show, params: { id: light.id }

      expect(response.body).to eq(json)
    end

    it "returns a not found status code" do
      other_home = create(:home)
      light = create(:light, home: other_home)

      authenticate(home.user)
      get :show, params: { id: light.id }

      expect(response).to have_http_status(:not_found)
    end
  end

  context "POST #create" do
    it "creates a user light" do
      light_params = attributes_for(:light, home: home)

      authenticate(home.user)

      expect do
        post :create, params: { home_id: home.id, thing: light_params }
      end.to change { Things::Light.count }.by(1)
    end

    it "creates a light" do
      light_params = attributes_for(:light, home: home)

      authenticate(home.user)

      expect do
        post :create, params: { home_id: home.id, thing: light_params }
      end.to change { Things::Light.count }.by(1)
    end

    it "creates a lock" do
      light_params = attributes_for(:lock, type: "Things::Lock", home: home)

      authenticate(home.user)

      expect do
        post :create, params: { home_id: home.id, thing: light_params }
      end.to change { Things::Lock.count }.by(1)
    end

    it "creates a thermostat" do
      light_params = attributes_for(:thermostat, home: home)

      authenticate(home.user)

      expect do
        post :create, params: { home_id: home.id, thing: light_params }
      end.to change { Things::Thermostat.count }.by(1)
    end

    it "creates a weather" do
      light_params = attributes_for(:weather, home: home)

      authenticate(home.user)

      expect do
        post :create, params: { home_id: home.id, thing: light_params }
      end.to change { Things::Weather.count }.by(1)
    end

    it "creates a motion_sensor" do
      light_params = attributes_for(:motion_sensor, home: home)

      authenticate(home.user)

      expect do
        post :create, params: { home_id: home.id, thing: light_params }
      end.to change { Things::MotionSensor.count }.by(1)
    end

    it "returns the created resource" do
      light_params = attributes_for(:light, home: home)

      authenticate(home.user)
      post :create, params: { home_id: home.id, thing: light_params }

      expect(parsed_response[:name]).to eq(light_params[:name])
      expect(parsed_response[:type]).to eq(light_params[:type])
      expect(parsed_response[:subtype]).to eq(light_params[:subtype])
      expect(parsed_response[:connection_info]).to eq(light_params[:connection_info])
    end

    it "returns a not found status code" do
      other_home = create(:home)
      light_params = attributes_for(:light)

      authenticate(home.user)
      post :create, params: { home_id: other_home.id, thing: light_params }

      expect(response).to have_http_status(:not_found)
    end
  end

  describe "PUT #update" do
    it "updates the info of a thing" do
      light = create(:light, home: home)
      light_params = attributes_for(:light)

      authenticate(home.user)
      put :update, params: { id: light.id, thing: light_params }
      light.reload

      expect(light.name).to eq(light_params[:name])
      expect(light.type).to eq(light_params[:type])
      expect(light.subtype).to eq(light_params[:subtype])
      expect(light.connection_info).to eq(light_params[:connection_info])
    end

    it "returns a not found status code" do
      other_home = create(:home)
      light = create(:light, home: other_home)
      light_params = attributes_for(:light)

      authenticate(home.user)
      put :update, params: { id: light.id, thing: light_params }

      expect(response).to have_http_status(:not_found)
    end
  end

  describe "DELETE #destroy" do
    it "destroys the requested light" do
      light = create(:light, home: home)

      authenticate(home.user)

      expect do
        delete :destroy, params: { id: light.id }
      end.to change { Thing.count }.by(-1)
    end

    it "returns a not found status code" do
      other_home = create(:home)
      light = create(:light, home: other_home)

      authenticate(home.user)
      delete :destroy, params: { id: light.id }

      expect(response).to have_http_status(:not_found)
    end
  end
end
