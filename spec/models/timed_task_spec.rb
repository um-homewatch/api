require "rails_helper"

RSpec.describe Tasks::TimedTask, type: :model do
  describe "attribute validation" do
    it "should validate that thing belongs to home" do
      thing = create(:light)
      timed_task = build(:timed_task, thing: thing)

      expect(timed_task).to be_invalid
    end

    it "should validate that task has both scenario and thing" do
      thing = create(:light)
      scenario = create(:scenario)
      timed_task = build(:timed_task, thing: thing, scenario: scenario)

      expect(timed_task).to be_invalid
    end
  end

  describe "relation validation" do
    it { should belong_to(:thing) }
    it { should belong_to(:home) }
    it { should belong_to(:delayed_job).class_name("Delayed::Job") }
  end
end
