require "rails_helper"

describe UserTokenController, type: :controller do
  context "POST #create" do
    it "returns the user and a token" do
      user = create(:user)
      auth_params = { email: user.email, password: user.password }

      post :create, params: { auth: auth_params }

      expect(parsed_response[:name]).to eq(user.name)
      expect(parsed_response[:email]).to eq(user.email)
      expect(parsed_response[:jwt]).to be
    end
  end
end
