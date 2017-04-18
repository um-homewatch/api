require "rails_helper"

describe Things::WeathersController, type: :controller do
  let(:home) { create(:home) }

  describe "GET #index" do
    it "returns the weather stations of a home" do
      weathers = create_list(:weather, 3, home: home)
      json = serialize_to_json(weathers)

      authenticate(home.user)
      get :index, params: { home_id: home.id }

      expect(response.body).to eq(json)
    end
  end

  describe "GET #show" do
    it "returns a weather station from a home" do
      weather = create(:weather, home: home)
      json = serialize_to_json(weather)

      authenticate(home.user)
      get :show, params: { home_id: home.id, id: weather.id }

      expect(response.body).to eq(json)
    end

    it "returns a not found status code" do
      weather = create(:weather)

      authenticate(home.user)
      get :show, params: { home_id: home.id, id: weather.id }

      expect(response).to have_http_status(:not_found)
    end
  end

  context "POST #create" do
    it "creates a user weather station" do
      weather_params = attributes_for(:weather, home: home)

      authenticate(home.user)

      expect do
        post :create, params: { home_id: home.id, weather: weather_params }
      end.to change { home.weathers.count }.by(1)
    end

    it "returns the created resource" do
      weather_params = attributes_for(:weather)

      authenticate(home.user)
      post :create, params: { home_id: home.id, weather: weather_params }

      expect(parsed_response[:subtype]).to eq(weather_params[:subtype])
      expect(parsed_response[:connection_info]).to eq(weather_params[:connection_info])
    end
  end

  describe "PUT #update" do
    it "updates the info of a weather station" do
      weather = create(:weather, home: home)
      weather_params = attributes_for(:weather)

      authenticate(home.user)
      put :update, params: { home_id: home.id, id: weather.id, weather: weather_params }
      weather.reload

      expect(weather.subtype).to eq(weather_params[:subtype])
      expect(weather.connection_info).to eq(weather_params[:connection_info])
    end

    it "returns a not found status code" do
      weather = create(:weather)
      weather_params = attributes_for(:weather)

      authenticate(home.user)
      put :update, params: { home_id: home.id, id: weather.id, weather: weather_params }

      expect(response).to have_http_status(:not_found)
    end
  end

  describe "DELETE #destroy" do
    it "destroys the requested weather station" do
      weather = create(:weather, home: home)

      authenticate(home.user)

      expect do
        delete :destroy, params: { home_id: home.id, id: weather.id }
      end.to change { home.weathers.count }.by(-1)
    end

    it "returns a not found status code" do
      weather = create(:weather)

      authenticate(home.user)
      delete :destroy, params: { home_id: home.id, id: weather.id }

      expect(response).to have_http_status(:not_found)
    end
  end
end
