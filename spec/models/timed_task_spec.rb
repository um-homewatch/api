require "rails_helper"

RSpec.describe Tasks::TimedTask, type: :model do
  describe "attribute validation" do
    let(:home) { create(:home) }

    it "should validate that thing belongs to home" do
      thing = create(:light)
      timed_task = build(:timed_task, thing: thing, home: home)

      expect(timed_task).to be_invalid
      expect(timed_task.errors[:thing_id].empty?).to be(false)
    end

    it "should invalidate because task has both scenario and thing" do
      thing = create(:light, home: home)
      scenario = create(:scenario, home: home)
      timed_task = build(:timed_task, home: home, thing: thing, scenario: scenario)

      expect(timed_task).to be_invalid
      expect(timed_task.errors[:scenario_id].empty?).to be(false)
      expect(timed_task.errors[:thing_id].empty?).to be(false)
    end

    it "should invalidate because status doesn't match thing" do
      status = { locked: false }
      thing = create(:light, home: home)
      timed_task = build(:timed_task, home: home, thing: thing, status: status)

      expect(timed_task).to be_invalid
      expect(timed_task.errors[:status].empty?).to be(false)
    end
  end

  describe "relation validation" do
    it { should belong_to(:thing) }
    it { should belong_to(:home) }
    it { should belong_to(:delayed_job).class_name("Delayed::Job") }
  end
end
