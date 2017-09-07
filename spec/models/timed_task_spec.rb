require "rails_helper"

RSpec.describe Tasks::TimedTask, type: :model do
  describe "attribute validation" do
    let(:home) { create(:home) }

    it "should validate that thing belongs to home" do
      thing = create(:light)
      timed_task = build(:timed_task, thing: thing, home: home)

      expect(timed_task).to be_invalid
      expect(timed_task.errors[:thing_id]).not_to be_empty
    end

    it "should invalidate because task has both scenario and thing" do
      thing = create(:light, home: home)
      scenario = create(:scenario, home: home)
      timed_task = build(:timed_task, home: home, thing: thing, scenario: scenario)

      expect(timed_task).to be_invalid
      expect(timed_task.errors[:scenario_id]).not_to be_empty
      expect(timed_task.errors[:thing_id]).not_to be_empty
    end

    it "should invalidate because task has neither a scenario and thing" do
      timed_task = build(:timed_task, home: home, thing: nil, scenario: nil)

      expect(timed_task).to be_invalid
      expect(timed_task.errors[:scenario_id]).not_to be_empty
      expect(timed_task.errors[:thing_id]).not_to be_empty
    end

    it "should invalidate because task has thing but no status to apply" do
      thing = create(:light, home: home)
      timed_task = build(:timed_task, home: home, thing: thing, status_to_apply: nil)

      expect(timed_task).to be_invalid
      expect(timed_task.errors[:status_to_apply]).not_to be_empty
    end

    it "should invalidate because status doesn't match thing" do
      status_to_apply = { locked: false }
      thing = create(:light, home: home)
      timed_task = build(:timed_task, home: home, thing: thing, status_to_apply: status_to_apply)

      expect(timed_task).to be_invalid
      expect(timed_task.errors[:status_to_apply]).not_to be_empty
    end
  end

  describe "relation validation" do
    it { should belong_to(:thing) }
    it { should belong_to(:home) }
    it { should belong_to(:delayed_job).class_name("Delayed::Job") }
  end
end
