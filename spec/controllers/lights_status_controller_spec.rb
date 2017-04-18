require "rails_helper"

describe Things::Status::LightController, type: :controller do
  let(:home) { create(:home) }

  describe "GET #show" do
    it "returns the status of a light" do
      light = create(:light, home: home)
      stub_status!(light, on: true)

      authenticate(home.user)
      get :show, params: { home_id: home.id, light_id: light.id }

      expect(parsed_response[:on]).to be_truthy
    end
  end

  describe "PUT #update" do
    it "should update the status of a light" do
      light = create(:light, home: home)
      stub_send_status!(light, on: false)

      authenticate(home.user)
      put :update, params: { home_id: home.id, light_id: light.id, status: { on: false } }

      expect(parsed_response[:on]).to be_falsey
    end
  end
end
