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
end
