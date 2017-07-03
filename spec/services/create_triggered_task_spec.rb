require "rails_helper"

describe CreateTriggeredTask do
  let(:home) { create(:home) }
  let(:thing_to_compare) { create(:light, home: home) }
  let(:thing) { create(:light, home: home) }
  let(:scenario) { create(:scenario, home: home) }

  describe "perform" do
    it "should create a triggered task" do
      params = attributes_for(:triggered_task, thing_to_compare: thing_to_compare, thing: thing)
      create_triggered_task = CreateTriggeredTask.new(home: home, params: params)

      expect do
        create_triggered_task.perform
      end.to change { Tasks::TriggeredTask.count }.by(1)
    end

    it "should create a delayed job" do
      params = attributes_for(:triggered_task, thing_to_compare: thing_to_compare, thing: thing)
      create_triggered_task = CreateTriggeredTask.new(home: home, params: params)

      expect do
        create_triggered_task.perform
      end.to change { Delayed::Job.count }.by(1)
    end

    it "should set status to true if saved" do
      params = attributes_for(:triggered_task, thing_to_compare: thing_to_compare, thing: thing)
      create_triggered_task = CreateTriggeredTask.new(home: home, params: params)

      create_triggered_task.perform

      expect(create_triggered_task).to be_truthy
    end

    it "should create a triggered task with the provided params" do
      params = attributes_for(:triggered_task, thing_to_compare: thing_to_compare, thing: thing)
      create_triggered_task = CreateTriggeredTask.new(home: home, params: params)

      triggered_task = create_triggered_task.perform

      expect(triggered_task.thing).to eq(thing)
      expect(triggered_task.delayed_job.cron).to eq("*/5 * * * * *")
      expect(triggered_task.status_to_apply.symbolize_keys).to eq(params[:status_to_apply])
      expect(triggered_task.status_to_compare.symbolize_keys).to eq(params[:status_to_compare])
      expect(triggered_task.comparator).to eq(params[:comparator])
    end

    it "should set status to false if it fails" do
      params = attributes_for(:triggered_task, thing_to_compare: thing_to_compare, thing: thing)
      create_triggered_task = CreateTriggeredTask.new(home: create(:home), params: params)

      # should fail the 'thing belongs to home' validation
      create_triggered_task.perform

      expect(create_triggered_task.status).to be_falsy
    end

    it "should not create a job if service fails" do
      params = attributes_for(:triggered_task, thing_to_compare: thing_to_compare, thing: thing)
      create_triggered_task = CreateTriggeredTask.new(home: create(:home), params: params)

      # should fail the 'thing belongs to home' validation
      create_triggered_task.perform

      expect do
        create_triggered_task.perform
      end.to change { Delayed::Job.count }.by(0)
    end

    it "should not create a triggered task if service fails" do
      params = attributes_for(:triggered_task, thing_to_compare: thing_to_compare, thing: thing)
      create_triggered_task = CreateTriggeredTask.new(home: create(:home), params: params)

      # should fail the 'thing belongs to home' validation
      create_triggered_task.perform

      expect do
        create_triggered_task.perform
      end.to change { Tasks::TriggeredTask.count }.by(0)
    end
  end

  describe "perform with scenario" do
    it "should create a triggered task with the provided params" do
      params = attributes_for(:triggered_task, scenario: scenario, thing_to_compare: thing_to_compare)
      create_triggered_task = CreateTriggeredTask.new(home: scenario.home, params: params)

      triggered_task = create_triggered_task.perform

      expect(triggered_task.scenario).to eq(scenario)
      expect(triggered_task.delayed_job.cron).to eq("*/5 * * * * *")
      expect(triggered_task.status_to_apply.symbolize_keys).to eq(params[:status_to_apply])
      expect(triggered_task.status_to_compare.symbolize_keys).to eq(params[:status_to_compare])
      expect(triggered_task.comparator).to eq(params[:comparator])
    end
  end
end
