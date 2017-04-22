require "rails_helper"

describe Things::WeathersController, type: :controller do
  let(:home) { create(:home) }

  context "POST #create" do
    it "creates a user weather station" do
      weather_params = attributes_for(:weather, home: home)

      authenticate(home.user)

      expect do
        post :create, params: { home_id: home.id, thing: weather_params }
      end.to change { home.weathers.count }.by(1)
    end

    it "returns the created resource" do
      weather_params = attributes_for(:weather)

      authenticate(home.user)
      post :create, params: { home_id: home.id, thing: weather_params }

      expect(parsed_response[:subtype]).to eq(weather_params[:subtype])
      expect(parsed_response[:connection_info]).to eq(weather_params[:connection_info])
    end

    it "returns a not found status code" do
      other_home = create(:home)
      weather_params = attributes_for(:weather)

      authenticate(home.user)
      post :create, params: { home_id: other_home.id, thing: weather_params }

      expect(response).to have_http_status(:not_found)
    end
  end
end
