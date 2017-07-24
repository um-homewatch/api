require "rails_helper"

describe CreateHome do
  let(:user) { create(:user) }
  let(:params) { attributes_for(:home, user: user) }

  describe "perform" do
    it "should create a home" do
      params = attributes_for(:home, user: user)
      create_home = CreateHome.new(user: user, params: params)

      expect do
        create_home.perform
      end.to change { Home.count }.by(1)
    end

    it "should create two delayed jobs" do
      create_home = CreateHome.new(user: user, params: params)

      expect do
        create_home.perform
      end.to change { Delayed::Job.count }.by(2)
    end

    it "should set status to true if saved" do
      create_home = CreateHome.new(user: user, params: params)

      create_home.perform

      expect(create_home).to be_truthy
    end

    it "should create a home with the provided params" do
      create_home = CreateHome.new(user: user, params: params)

      home = create_home.perform

      expect(home.name).to eq(params[:name])
      expect(home.tunnel).to eq(params[:tunnel])
      expect(home.location).to eq(params[:location])
      expect(home.ip_address).to be
    end

    it "should call the fetch_token method" do
      create_home = CreateHome.new(user: user, params: params)

      expect_any_instance_of(Home).to receive(:delay).twice.and_call_original

      create_home.perform
    end

    it "should set status to false if it fails" do
      params.delete(:tunnel)
      create_home = CreateHome.new(user: user, params: params)

      # should fail because there are missing params
      create_home.perform

      expect(create_home.status).to be_falsy
    end

    it "should not create a job if service fails" do
      params.delete(:tunnel)
      create_home = CreateHome.new(user: user, params: params)

      # should fail because there are missing params
      create_home.perform

      expect do
        create_home.perform
      end.to change { Delayed::Job.count }.by(0)
    end

    it "should not create a home if service fails" do
      params.delete(:tunnel)
      create_home = CreateHome.new(user: user, params: params)

      # should fail because there are missing params
      create_home.perform

      expect do
        create_home.perform
      end.to change { Home.count }.by(0)
    end
  end
end
