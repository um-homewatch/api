require "rails_helper"

describe CreateTimedTask do
  let(:thing) { create(:light) }
  let(:scenario) { create(:scenario) }

  describe "perform" do
    it "should create a timed task" do
      params = attributes_for(:timed_task_light, thing: thing, cron: "5 * * * *")
      create_timed_task = CreateTimedTask.new(home: thing.home, params: params)

      expect do
        create_timed_task.perform
      end.to change { Tasks::TimedTask.count }.by(1)
    end

    it "should create a delayed job" do
      params = attributes_for(:timed_task_light, thing: thing, cron: "5 * * * *")
      create_timed_task = CreateTimedTask.new(home: thing.home, params: params)

      expect do
        create_timed_task.perform
      end.to change { Delayed::Job.count }.by(1)
    end

    it "should set status to true if saved" do
      params = attributes_for(:timed_task_light, thing: thing, cron: "5 * * * *")
      create_timed_task = CreateTimedTask.new(home: thing.home, params: params)

      create_timed_task.perform

      expect(create_timed_task).to be_truthy
    end

    it "should create a timed task with the provided params" do
      params = attributes_for(:timed_task_light, thing: thing, cron: "5 * * * *")
      create_timed_task = CreateTimedTask.new(home: thing.home, params: params)

      timed_task = create_timed_task.perform

      expect(timed_task.thing).to eq(thing)
      expect(timed_task.delayed_job.cron).to eq(params[:cron])
      expect(timed_task.status.symbolize_keys).to eq(params[:status])
    end

    it "should set status to false if it fails" do
      params = attributes_for(:timed_task_light, thing: thing, cron: "5 * * * *")
      create_timed_task = CreateTimedTask.new(home: create(:home), params: params)

      # should fail the 'thing belongs to home' validation
      create_timed_task.perform

      expect(create_timed_task.status).to be_falsy
    end

    it "should not create a job if service fails" do
      params = attributes_for(:timed_task_light, thing: thing, cron: "5 * * * *")
      create_timed_task = CreateTimedTask.new(home: create(:home), params: params)

      # should fail the 'thing belongs to home' validation
      create_timed_task.perform

      expect do
        create_timed_task.perform
      end.to change { Delayed::Job.count }.by(0)
    end

    it "should not create a timed task if service fails" do
      params = attributes_for(:timed_task_light, thing: thing, cron: "5 * * * *")
      create_timed_task = CreateTimedTask.new(home: create(:home), params: params)

      # should fail the 'thing belongs to home' validation
      create_timed_task.perform

      expect do
        create_timed_task.perform
      end.to change { Tasks::TimedTask.count }.by(0)
    end
  end

  describe "perform with scenario" do
    it "should create a timed task with the provided params" do
      params = attributes_for(:timed_task_light, scenario: scenario, cron: "5 * * * *")
      create_timed_task = CreateTimedTask.new(home: scenario.home, params: params)

      timed_task = create_timed_task.perform

      expect(timed_task.scenario).to eq(scenario)
      expect(timed_task.delayed_job.cron).to eq(params[:cron])
      expect(timed_task.status.symbolize_keys).to eq(params[:status])
    end
  end
end
