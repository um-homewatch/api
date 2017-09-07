require "rails_helper"

describe Things::StatusController, type: :controller do
  let(:home) { create(:home) }

  describe "GET #show" do
    it "returns the status of a light" do
      light = create(:light, home: home)
      light_status = { on: true }
      stub_status!(light, light_status)

      authenticate(home.user)
      get :show, params: { thing_id: light.id }

      expect(parsed_response).to eq(light_status)
    end

    it "should return a not found response" do
      other_home = create(:home)
      light = create(:light, home: other_home)

      authenticate(home.user)
      get :show, params: { thing_id: light.id }

      expect(response).to be_not_found
    end

    it "should normalize the response code" do
      light = create(:light, home: home)
      light_status = { on: true }
      stub_status!(light, light_status, status_code: 123)

      authenticate(home.user)
      get :show, params: { thing_id: light.id }

      expect(response).to be_not_found
    end
  end

  describe "PUT #update" do
    it "should update the status of a light" do
      light = create(:light, home: home)
      light_status = { on: false }
      stub_send_status!(light, light_status, true)

      authenticate(home.user)
      put :update, params: { thing_id: light.id, status: light_status }

      expect(parsed_response).to eq(light_status)
    end

    it "should return a not found response" do
      other_home = create(:home)
      light = create(:light, home: other_home)

      authenticate(home.user)
      put :update, params: { thing_id: light.id }

      expect(response).to be_not_found
    end

    it "should normalize the response code" do
      light = create(:light, home: home)
      light_status = { on: false }
      stub_send_status!(light, light_status, true, status_code: 123)

      authenticate(home.user)
      put :update, params: { thing_id: light.id, status: light_status }

      expect(response).to be_not_found
    end
  end
end
