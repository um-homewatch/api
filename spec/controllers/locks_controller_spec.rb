require "rails_helper"

describe Things::LocksController, type: :controller do
  let(:home) { create(:home) }

  describe "GET #index" do
    it "returns the locks of a home" do
      locks = create_list(:lock, 3, home: home)
      json = serialize_to_json(locks)

      authenticate(home.user)
      get :index, params: { home_id: home.id }

      expect(response.body).to eq(json)
    end
  end

  describe "GET #show" do
    it "returns a lock from a home" do
      lock = create(:lock, home: home)
      json = serialize_to_json(lock)

      authenticate(home.user)
      get :show, params: { home_id: home.id, id: lock.id }

      expect(response.body).to eq(json)
    end

    it "returns a not found status code" do
      lock = create(:lock)

      authenticate(home.user)
      get :show, params: { home_id: home.id, id: lock.id }

      expect(response).to have_http_status(:not_found)
    end
  end

  context "POST #create" do
    it "creates a user lock" do
      lock_params = attributes_for(:lock, home: home)

      authenticate(home.user)

      expect do
        post :create, params: { home_id: home.id, lock: lock_params }
      end.to change { home.locks.count }.by(1)
    end

    it "returns the created resource" do
      lock_params = attributes_for(:lock)

      authenticate(home.user)
      post :create, params: { home_id: home.id, lock: lock_params }

      expect(parsed_response[:subtype]).to eq(lock_params[:subtype])
      expect(parsed_response[:connection_info]).to eq(lock_params[:connection_info])
    end
  end

  describe "PUT #update" do
    it "updates the info of a lock" do
      lock = create(:lock, home: home)
      lock_params = attributes_for(:lock)

      authenticate(home.user)
      put :update, params: { home_id: home.id, id: lock.id, lock: lock_params }
      lock.reload

      expect(lock.subtype).to eq(lock_params[:subtype])
      expect(lock.connection_info).to eq(lock_params[:connection_info])
    end

    it "returns a not found status code" do
      lock = create(:lock)
      lock_params = attributes_for(:lock)

      authenticate(home.user)
      put :update, params: { home_id: home.id, id: lock.id, lock: lock_params }

      expect(response).to have_http_status(:not_found)
    end
  end

  describe "DELETE #destroy" do
    it "destroys the requested lock" do
      lock = create(:lock, home: home)

      authenticate(home.user)

      expect do
        delete :destroy, params: { home_id: home.id, id: lock.id }
      end.to change { home.locks.count }.by(-1)
    end

    it "returns a not found status code" do
      lock = create(:lock)

      authenticate(home.user)
      delete :destroy, params: { home_id: home.id, id: lock.id }

      expect(response).to have_http_status(:not_found)
    end
  end
end
