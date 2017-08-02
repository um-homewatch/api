require "rails_helper"

RSpec.describe Tasks::TriggeredTask, type: :model do
  describe "attribute validation" do
    let(:home) { create(:home) }

    it "should validate that thing belongs to home" do
      thing = create(:light)
      triggered_task = build(:triggered_task, thing: thing, home: home)

      expect(triggered_task).to be_invalid
      expect(triggered_task.errors[:thing_id]).to_not be_empty
    end

    it "should validate that thing_to_compare belongs to home" do
      thing = create(:light)
      triggered_task = build(:triggered_task, thing_to_compare: thing, home: home, thing: create(:light, home: home))

      expect(triggered_task).to be_invalid
      expect(triggered_task.errors[:thing_to_compare_id]).to_not be_empty
    end

    it "should validate that task has both scenario and thing" do
      thing = create(:light, home: home)
      scenario = create(:scenario, home: home)
      triggered_task = build(:triggered_task, home: home, thing: thing, scenario: scenario)

      expect(triggered_task).to be_invalid
      expect(triggered_task.errors[:scenario_id]).to_not be_empty
      expect(triggered_task.errors[:thing_id]).to_not be_empty
    end

    it "should invalidate because task has neither a scenario and thing" do
      triggered_task = build(:triggered_task, home: home, thing: nil, scenario: nil)

      expect(triggered_task).to be_invalid
      expect(triggered_task.errors[:scenario_id]).not_to be_empty
      expect(triggered_task.errors[:thing_id]).not_to be_empty
    end

    it "should invalidate because status_to_compare doesn't match thing_to_compare" do
      status = { fail: false }
      thing = create(:light, home: home)
      triggered_task = build(:triggered_task, home: home, thing: thing, status_to_compare: status)

      expect(triggered_task).to be_invalid
      expect(triggered_task.errors[:status_to_compare]).to_not be_empty
    end

    it "should invalidate because status_to_apply doesn't match thing" do
      status = { locked: false }
      thing = create(:light, home: home)
      triggered_task = build(:triggered_task, home: home, thing: thing, status_to_apply: status)

      expect(triggered_task).to be_invalid
      expect(triggered_task.errors[:status_to_apply]).to_not be_empty
    end
  end

  describe "attribute validation" do
    subject { build(:triggered_task) }

    it { should validate_presence_of(:status_to_compare) }
    it { should validate_presence_of(:status_to_apply) }
    it { should validate_presence_of(:thing_to_compare) }
  end

  describe "relation validation" do
    it { should belong_to(:thing) }
    it { should belong_to(:home) }
    it { should belong_to(:delayed_job).class_name("Delayed::Job") }
  end

  describe "method validation" do
    it "should apply status" do
      task = create(:triggered_task)
      stub_status!(task.thing_to_compare, task.status_to_compare)

      expect(task).to receive(:apply)

      task.apply_if
    end

    it "should set 'should_apply?' to false" do
      task = create(:triggered_task)
      stub_status!(task.thing_to_compare, task.status_to_compare)
      expect(task).to receive(:apply)

      task.apply_if

      expect(task.should_apply?).to be(false)
    end

    it "should not apply status" do
      task = create(:triggered_task)
      stub_status!(task.thing_to_compare, on: false)

      expect(task).to_not receive(:apply)

      task.apply_if
    end

    it "should not apply status if 'should_apply?' flag is set" do
      task = create(:triggered_task, should_apply?: false)
      stub_status!(task.thing_to_compare, on: true)

      expect(task).to_not receive(:apply)

      task.apply_if
    end

    it "should set 'should_apply?' to true" do
      task = create(:triggered_task)
      stub_status!(task.thing_to_compare, on: false)

      expect(task).to_not receive(:apply)

      task.apply_if

      expect(task.should_apply?).to be(true)
    end
  end
end
