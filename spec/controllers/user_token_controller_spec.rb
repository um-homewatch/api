require "rails_helper"

describe UserTokenController, type: :controller do
  context "POST #create" do
    it "authenticates the user" do
      user = build(:user)
      auth_params = { email: user.email, password: user.password }
      user.save

      post :create, params: { auth: auth_params }

      expect(parsed_response[:jwt]).to be
    end
  end
end
