require "rails_helper"

describe ScenarioApplyController, type: :controller do
  context "POST #create" do
    it "applies a user scenario" do
      ActiveJob::Base.queue_adapter = :test
      scenario = create(:scenario)

      authenticate(scenario.home.user)

      expect do
        post :create, params: { scenario_id: scenario.id }
      end.to have_enqueued_job(ApplyScenarioJob)
    end
  end
end
