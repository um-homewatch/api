require "rails_helper"

describe UsersController, type: :controller do
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
end
