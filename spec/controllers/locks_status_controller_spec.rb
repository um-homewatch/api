require "rails_helper"

describe Things::Status::LockController, type: :controller do
  let(:home) { create(:home) }

  describe "GET #show" do
    it "returns the status of a lock" do
      lock = create(:lock, home: home)
      lock_status = { locked: true }
      stub_status!(lock, lock_status)

      authenticate(home.user)
      get :show, params: { home_id: home.id, lock_id: lock.id }

      expect(parsed_response).to eq(lock_status)
    end
  end

  describe "PUT #update" do
    it "should update the status of a lock" do
      lock = create(:lock, home: home)
      lock_status = { locked: false }
      stub_send_status!(lock, lock_status)

      authenticate(home.user)
      put :update, params: { home_id: home.id, lock_id: lock.id, status: lock_status }

      expect(parsed_response).to eq(lock_status)
    end
  end
end
