require "rails_helper"

describe Things::Status::LockController, type: :controller do
  let(:home) { create(:home) }

  describe "GET #show" do
    it "returns the status of a lock" do
      lock = create(:lock, home: home)
      stub_status!(lock, locked: true)

      authenticate(home.user)
      get :show, params: { home_id: home.id, lock_id: lock.id }

      expect(parsed_response[:locked]).to be_truthy
    end
  end

  describe "PUT #update" do
    it "should update the status of a lock" do
      lock = create(:lock, home: home)
      stub_send_status!(lock, locked: false)

      authenticate(home.user)
      put :update, params: { home_id: home.id, lock_id: lock.id, status: { on: false } }

      expect(parsed_response[:locked]).to be_falsey
    end
  end
end
