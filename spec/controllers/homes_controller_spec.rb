require "rails_helper"

describe HomesController, type: :controller do
  let(:user) { create(:user) }

  describe "GET #index" do
    it "returns the user's homes" do
      homes = create_list(:home, 3, user: user)
      json = serialize_to_json(homes)

      authenticate(user)
      get :index

      expect(response.body).to eq(json)
    end
  end

  describe "GET #show" do
    it "returns a user home" do
      home = create(:home, user: user)
      json = serialize_to_json(home)

      authenticate(user)
      get :show, params: { id: home.id }

      expect(response.body).to eq(json)
    end

    it "returns a not found status code" do
      home = create(:home)

      authenticate(user)
      get :show, params: { id: home.id }

      expect(response).to have_http_status(:not_found)
    end
  end

  context "POST #create" do
    it "creates a user home" do
      home_params = attributes_for(:home, user: user)

      authenticate(user)

      expect do
        post :create, params: { home: home_params }
      end.to change { user.homes.count }.by(1)
    end

    it "returns the created resource" do
      home_params = attributes_for(:home, user: user)

      authenticate(user)
      post :create, params: { home: home_params }

      expect(parsed_response[:name]).to eq(home_params[:name])
      expect(parsed_response[:tunnel]).to eq(home_params[:tunnel])
      expect(parsed_response[:location]).to eq(home_params[:location])
      expect(parsed_response[:ip_address]).to be
    end
  end

  describe "PUT #update" do
    it "updates a user home" do
      home = create(:home, user: user)
      home_params = attributes_for(:home, user: user)

      authenticate(user)
      put :update, params: { id: home.id, home: home_params }
      home.reload

      expect(home.name).to eq(home_params[:name])
      expect(home.tunnel).to eq(home_params[:tunnel])
      expect(home.location).to eq(home_params[:location])
      expect(home.ip_address).to be
    end

    it "returns a not found status code" do
      home = create(:home)
      home_params = attributes_for(:home)

      authenticate(user)
      put :update, params: { id: home.id, home: home_params }

      expect(response).to have_http_status(:not_found)
    end
  end

  describe "DELETE #destroy" do
    it "destroys the requested home" do
      home = create(:home, user: user)

      authenticate(user)

      expect do
        delete :destroy, params: { id: home.id }
      end.to change { user.homes.count }.by(-1)
    end

    it "returns a not found status code" do
      home = create(:home)

      authenticate(user)
      delete :destroy, params: { id: home.id }

      expect(response).to have_http_status(:not_found)
    end
  end
end
