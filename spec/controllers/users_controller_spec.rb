require "rails_helper"

describe UsersController, type: :controller do
  let(:user) { create(:user) }

  context "POST #create" do
    it "registers the user" do
      user_params = attributes_for(:user)

      post :create, params: { user: user_params }

      expect(parsed_response[:jwt]).to be
    end

    it "returns a auth token" do
      user_params = attributes_for(:user)

      post :create, params: { user: user_params }

      expect(parsed_response[:jwt]).to be
    end
  end

  context "GET #show" do
    it "renders the current user" do
      json = serialize_as_json(user)

      authenticate(user)
      get :show

      expect(parsed_response).to eq(json)
    end
  end

  context "PUT #create" do
    it "updates the user" do
      user_params = attributes_for(:user)

      authenticate(user)
      put :update, params: { user: user_params }
      user.reload

      expect(user.name).to eq(user_params[:name])
      expect(user.email).to eq(user_params[:email])
    end

    it "returns a auth token" do
      user_params = attributes_for(:user)

      authenticate(user)
      put :update, params: { user: user_params }

      expect(parsed_response[:jwt]).to be
    end
  end
end
