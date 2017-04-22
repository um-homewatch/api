require "rails_helper"

describe Things::LightsController, type: :controller do
  let(:home) { create(:home) }

  context "POST #create" do
    it "creates a user light" do
      light_params = attributes_for(:light, home: home)

      authenticate(home.user)

      expect do
        post :create, params: { home_id: home.id, thing: light_params }
      end.to change { Things::Light.count }.by(1)
    end

    it "returns the created resource" do
      light_params = attributes_for(:light)

      authenticate(home.user)
      post :create, params: { home_id: home.id, thing: light_params }

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
end
