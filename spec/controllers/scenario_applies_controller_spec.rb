require "rails_helper"

describe ScenarioAppliesController, type: :controller do
  context "POST #create" do
    it "applies a user scenario" do
      scenario = create(:scenario)

      authenticate(scenario.home.user)

      expect do
        post :create, params: { scenario_id: scenario.id }
      end.to change { Delayed::Job.count }.by(1)
    end
  end
end
