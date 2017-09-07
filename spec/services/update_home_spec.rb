require "rails_helper"

describe UpdateHome do
  let(:home) { create(:home) }
  let(:params) { attributes_for(:home) }
  before { allow(home).to receive(:fetch_token) }

  describe "perform" do
    it "should set status to true if updated" do
      update_home = UpdateHome.new(home: home, params: params)

      update_home.perform

      expect(update_home).to be_truthy
    end

    it "should create a home with the provided params" do
      update_home = UpdateHome.new(home: home, params: params)

      home = update_home.perform

      expect(home.name).to eq(params[:name])
      expect(home.tunnel).to eq(params[:tunnel])
      expect(home.location).to eq(params[:location])
      expect(home.ip_address).to be
    end

    it "should call the fetch_token method" do
      update_home = UpdateHome.new(home: home, params: params)

      expect_any_instance_of(Home).to receive(:delay).twice.and_call_original

      update_home.perform
    end

    it "should set status to false if it fails" do
      params[:tunnel] = nil
      update_home = UpdateHome.new(home: home, params: params)

      # should fail because there are missing params
      update_home.perform

      expect(update_home.status).to be_falsy
    end
  end
end
