require "rails_helper"

describe Scenario, type: :model do
  describe "attribute validation" do
    subject { build(:home) }

    it { should validate_presence_of(:name) }
  end

  describe "relation validation" do
    it { should have_many(:scenario_things) }
  end

  describe "methods" do
    it "should apply all the statuses of this scenario" do
      scenario = create(:scenario)
      scenario_things = create_list(:scenario_thing, 3, scenario: scenario)

      scenario_things.each do |scenario_thing|
        stub_send_status!(scenario_thing.thing, scenario_thing.status)
      end

      expect(scenario.apply).to eq(true)
    end

    it "should only apply one status out of two, failing in the end" do
      scenario = create(:scenario)
      good_scenario_thing = create(:scenario_thing, scenario: scenario)
      bad_scenario_thing = create(:scenario_thing, scenario: scenario)

      stub_send_status!(good_scenario_thing.thing, good_scenario_thing.status)
      stub_send_status!(bad_scenario_thing.thing, bad_scenario_thing.status, status_code: 500)

      expect(scenario.apply).to eq(false)
    end

    it "should fail to apply all things" do
      scenario = create(:scenario)
      scenario_things = create_list(:scenario_thing, 3, scenario: scenario)

      scenario_things.each do |scenario_thing|
        stub_send_status!(scenario_thing.thing, scenario_thing.status, status_code: 500)
      end

      expect(scenario.apply).to eq(false)
    end
  end
end
