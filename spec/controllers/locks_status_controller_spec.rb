require "rails_helper"

describe Things::StatusController, type: :controller do
  let(:home) { create(:home) }

  describe "GET #show" do
    it "returns the status of a lock" do
      lock = create(:lock, home: home)
      lock_status = { locked: true }
      stub_status!(lock, lock_status)

      authenticate(home.user)
      get :show, params: { thing_id: lock.id }

      expect(parsed_response).to eq(lock_status)
    end

    it "should return a not found response" do
      other_home = create(:home)
      lock = create(:lock, home: other_home)

      authenticate(home.user)
      get :show, params: { thing_id: lock.id }

      expect(response).to be_not_found
    end
  end

  describe "PUT #update" do
    it "should update the status of a lock" do
      lock = create(:lock, home: home)
      lock_status = { locked: false }
      stub_send_status!(lock, lock_status, true)

      authenticate(home.user)
      put :update, params: { thing_id: lock.id, status: lock_status }

      expect(parsed_response).to eq(lock_status)
    end

    it "should return a not found response" do
      other_home = create(:home)
      lock = create(:lock, home: other_home)

      authenticate(home.user)
      put :update, params: { thing_id: lock.id }

      expect(response).to be_not_found
    end
  end
end
