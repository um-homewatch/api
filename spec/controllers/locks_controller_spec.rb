require "rails_helper"

describe Things::LocksController, type: :controller do
  let(:home) { create(:home) }

  context "POST #create" do
    it "creates a user lock" do
      lock_params = attributes_for(:lock, home: home)

      authenticate(home.user)

      expect do
        post :create, params: { home_id: home.id, thing: lock_params }
      end.to change { home.locks.count }.by(1)
    end

    it "returns the created resource" do
      lock_params = attributes_for(:lock)

      authenticate(home.user)
      post :create, params: { home_id: home.id, thing: lock_params }

      expect(parsed_response[:subtype]).to eq(lock_params[:subtype])
      expect(parsed_response[:connection_info]).to eq(lock_params[:connection_info])
    end

    it "returns a not found status code" do
      other_home = create(:home)
      lock_params = attributes_for(:lock)

      authenticate(home.user)
      post :create, params: { home_id: other_home.id, thing: lock_params }

      expect(response).to have_http_status(:not_found)
    end
  end
end
