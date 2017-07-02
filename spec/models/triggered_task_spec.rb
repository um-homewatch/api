require "rails_helper"

RSpec.describe Tasks::TriggeredTask, type: :model do
  describe "attribute validation" do
    it "should validate that thing belongs to home" do
      thing = create(:light)
      triggered_task = build(:triggered_task, thing: thing)

      expect(triggered_task).to be_invalid
    end

    it "should validate that task has both scenario and thing" do
      thing = create(:light)
      scenario = create(:scenario)
      triggered_task = build(:triggered_task, thing: thing, scenario: scenario)

      expect(triggered_task).to be_invalid
    end
  end

  describe "relation validation" do
    it { should belong_to(:thing) }
    it { should belong_to(:home) }
    it { should belong_to(:delayed_job).class_name("Delayed::Job") }
  end

  describe "method validation" do
    it "should apply status" do
      task = create(:triggered_task_light, status_to_compare: { on: true })
      stub_status!(task.thing, on: true)

      expect(task).to receive(:apply)

      task.apply_if
    end

    it "should not apply status" do
      task = create(:triggered_task_light, status_to_compare: { on: true })
      stub_status!(task.thing, on: false)

      expect(task).to_not receive(:apply)

      task.apply_if
    end
  end
end
