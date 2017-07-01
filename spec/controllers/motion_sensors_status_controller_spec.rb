require "rails_helper"

describe Things::StatusController, type: :controller do
  let(:home) { create(:home) }

  describe "GET #show" do
    it "returns the status of a motion_sensor" do
      motion_sensor = create(:motion_sensor, home: home)
      motion_sensor_status = { on: true }
      stub_status!(motion_sensor, motion_sensor_status)

      authenticate(home.user)
      get :show, params: { thing_id: motion_sensor.id }

      expect(parsed_response).to eq(motion_sensor_status)
    end

    it "should return a not found response" do
      other_home = create(:home)
      motion_sensor = create(:motion_sensor, home: other_home)

      authenticate(home.user)
      get :show, params: { thing_id: motion_sensor.id }

      expect(response).to be_not_found
    end
  end

  describe "PUT #update" do
    it "should return 400" do
      motion_sensor = create(:motion_sensor, home: home)
      motion_sensor_status = { movement: Faker::Boolean.boolean }
      stub_send_status!(motion_sensor, motion_sensor_status, true)

      authenticate(home.user)
      put :update, params: { thing_id: motion_sensor.id, status: motion_sensor_status }

      expect(response).to be_bad_request
    end

    it "should return a not found response" do
      other_home = create(:home)
      motion_sensor = create(:motion_sensor, home: other_home)

      authenticate(home.user)
      put :update, params: { thing_id: motion_sensor.id }

      expect(response).to be_not_found
    end
  end
end
