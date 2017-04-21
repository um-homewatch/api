require "rails_helper"

describe ApplyScenarioJob, type: :job do
  it "should perform the statuses update" do
    scenario = create(:scenario)
    scenario_things = create_list(:scenario_light, 3, scenario: scenario)

    scenario_things.each do |scenario_thing|
      stub_send_status!(scenario_thing.thing, scenario_thing.status)
    end

    expect(ApplyScenarioJob.perform_now(scenario)).to eq(true)
  end
end
