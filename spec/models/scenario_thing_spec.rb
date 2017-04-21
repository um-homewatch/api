require "rails_helper"

describe ScenarioThing, type: :model do
  describe "attribute validation" do
    it "should validate thing uniqueness" do
      scenario_thing = create(:scenario_light)
      other_scenario_thing = build(:scenario_thing, thing: scenario_thing.thing, scenario: scenario_thing.scenario)

      expect(other_scenario_thing).to be_invalid
    end
  end

  describe "relation validation" do
    it { should belong_to(:thing) }
    it { should belong_to(:scenario) }
  end

  describe "methods" do
    it "should send the status of the thing" do
      scenario_thing = create(:scenario_light)
      stub_send_status!(scenario_thing.thing, scenario_thing.status)

      expect(scenario_thing.apply).to eq(true)
    end

    it "should fail to send the status of the thing" do
      scenario_thing = create(:scenario_light)
      stub_send_status!(scenario_thing.thing, scenario_thing.status, status_code: 500)

      expect(scenario_thing.apply).to eq(false)
    end
  end
end
