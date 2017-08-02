require "rails_helper"

describe CreateTimedTask do
  let(:cron) { "5 * * * *" }
  let(:timed_task_params) { attributes_with_foreign_keys(:timed_task).merge(cron: cron) }
  let(:home) { Home.find(timed_task_params[:home_id]) }

  describe "perform" do
    it "should create a timed task" do
      create_timed_task = CreateTimedTask.new(home: home, params: timed_task_params)

      expect do
        create_timed_task.perform
      end.to change { Tasks::TimedTask.count }.by(1)
    end

    it "should create a delayed job" do
      create_timed_task = CreateTimedTask.new(home: home, params: timed_task_params)

      expect do
        create_timed_task.perform
      end.to change { Delayed::Job.count }.by(1)
    end

    it "should set status to true if saved" do
      create_timed_task = CreateTimedTask.new(home: home, params: timed_task_params)

      create_timed_task.perform

      expect(create_timed_task).to be_truthy
    end

    it "should create a timed task with the provided params" do
      create_timed_task = CreateTimedTask.new(home: home, params: timed_task_params)

      timed_task = create_timed_task.perform

      expect(timed_task.thing.id).to eq(timed_task_params[:thing_id])
      expect(timed_task.delayed_job.cron).to eq(timed_task_params[:cron])
      expect(timed_task.status_to_apply.symbolize_keys).to eq(timed_task_params[:status_to_apply])
    end

    it "should set status to false if it fails" do
      create_timed_task = CreateTimedTask.new(home: create(:home), params: timed_task_params)

      # should fail the 'thing belongs to home' validation
      create_timed_task.perform

      expect(create_timed_task.status).to be_falsy
    end

    it "should not create a job if service fails" do
      create_timed_task = CreateTimedTask.new(home: create(:home), params: timed_task_params)

      # should fail the 'thing belongs to home' validation
      create_timed_task.perform

      expect do
        create_timed_task.perform
      end.to change { Delayed::Job.count }.by(0)
    end

    it "should not create a timed task if service fails" do
      create_timed_task = CreateTimedTask.new(home: create(:home), params: timed_task_params)

      # should fail the 'thing belongs to home' validation
      create_timed_task.perform

      expect do
        create_timed_task.perform
      end.to change { Tasks::TimedTask.count }.by(0)
    end
  end

  describe "perform with scenario" do
    it "should create a timed task with the provided params" do
      timed_task_params = attributes_with_foreign_keys(:timed_task, :scenario).merge(cron: cron)
      home = Home.find(timed_task_params[:home_id])
      create_timed_task = CreateTimedTask.new(home: home, params: timed_task_params)

      timed_task = create_timed_task.perform

      expect(timed_task.scenario.id).to eq(timed_task_params[:scenario_id])
      expect(timed_task.delayed_job.cron).to eq(timed_task_params[:cron])
      expect(timed_task.status_to_apply.symbolize_keys).to eq(timed_task_params[:status_to_apply])
    end
  end
end
