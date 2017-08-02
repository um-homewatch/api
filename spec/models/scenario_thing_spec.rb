require "rails_helper"

describe ScenarioThing, type: :model do
  describe "attribute validation" do
    it "should validate thing uniqueness" do
      scenario_thing = create(:scenario_thing)
      other_scenario_thing = build(:scenario_thing, thing: scenario_thing.thing, scenario: scenario_thing.scenario)

      expect(other_scenario_thing).to be_invalid
      expect(other_scenario_thing.errors[:thing_id]).to_not be_empty
    end

    it "should validate that thing belongs to user" do
      thing = create(:light)
      scenario_thing = build(:scenario_thing, thing: thing)

      expect(scenario_thing).to be_invalid
      expect(scenario_thing.errors[:thing_id]).to_not be_empty
    end

    it "should invalidate when thing is read only" do
      thing = create(:weather)
      scenario_thing = build(:scenario_thing, thing: thing)

      expect(scenario_thing).to be_invalid
      expect(scenario_thing.errors[:thing_id]).to_not be_empty
    end

    it "should invalidate when status is not valid" do
      thing = create(:light)
      scenario_thing = build(:scenario_thing, thing: thing, status: { fail: true })

      expect(scenario_thing).to be_invalid
      expect(scenario_thing.errors[:status]).to_not be_empty
    end
  end

  describe "relation validation" do
    it { should belong_to(:thing) }
    it { should belong_to(:scenario) }
  end

  describe "methods" do
    it "should send the status of the thing" do
      scenario_thing = create(:scenario_thing)
      stub_send_status!(scenario_thing.thing, scenario_thing.status)

      expect(scenario_thing.apply).to eq(true)
    end

    it "should fail to send the status of the thing" do
      scenario_thing = create(:scenario_thing)
      stub_send_status!(scenario_thing.thing, scenario_thing.status, status_code: 500)

      expect(scenario_thing.apply).to eq(false)
    end
  end
end
