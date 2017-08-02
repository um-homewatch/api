require "rails_helper"

describe CreateTriggeredTask do
  let(:cron) { "5 * * * *" }
  let(:triggered_task_params) { attributes_with_foreign_keys(:triggered_task) }
  let(:home) { Home.find(triggered_task_params[:home_id]) }

  describe "perform" do
    it "should create a triggered task" do
      create_triggered_task = CreateTriggeredTask.new(home: home, params: triggered_task_params)

      expect do
        create_triggered_task.perform
      end.to change { Tasks::TriggeredTask.count }.by(1)
    end

    it "should create a delayed job" do
      create_triggered_task = CreateTriggeredTask.new(home: home, params: triggered_task_params)

      expect do
        create_triggered_task.perform
      end.to change { Delayed::Job.count }.by(1)
    end

    it "should set status to true if saved" do
      create_triggered_task = CreateTriggeredTask.new(home: home, params: triggered_task_params)

      create_triggered_task.perform

      expect(create_triggered_task).to be_truthy
    end

    it "should create a triggered task with the provided params" do
      create_triggered_task = CreateTriggeredTask.new(home: home, params: triggered_task_params)

      triggered_task = create_triggered_task.perform

      expect(triggered_task.delayed_job.cron).to eq(POLLING_RATE_CRON)
      expect(triggered_task.thing.id).to eq(triggered_task_params[:thing_id])
      expect(triggered_task.thing_to_compare.id).to eq(triggered_task_params[:thing_to_compare_id])
      expect(triggered_task.status_to_apply.symbolize_keys).to eq(triggered_task_params[:status_to_apply])
      expect(triggered_task.status_to_compare.symbolize_keys).to eq(triggered_task_params[:status_to_compare])
      expect(triggered_task.comparator).to eq(triggered_task_params[:comparator])
    end

    it "should set status to false if it fails" do
      create_triggered_task = CreateTriggeredTask.new(home: create(:home), params: triggered_task_params)

      # should fail the 'thing belongs to home' validation
      create_triggered_task.perform

      expect(create_triggered_task.status).to be_falsy
    end

    it "should not create a job if service fails" do
      create_triggered_task = CreateTriggeredTask.new(home: create(:home), params: triggered_task_params)

      # should fail the 'thing belongs to home' validation
      create_triggered_task.perform

      expect do
        create_triggered_task.perform
      end.to change { Delayed::Job.count }.by(0)
    end

    it "should not create a triggered task if service fails" do
      create_triggered_task = CreateTriggeredTask.new(home: create(:home), params: triggered_task_params)

      # should fail the 'thing belongs to home' validation
      create_triggered_task.perform

      expect do
        create_triggered_task.perform
      end.to change { Tasks::TriggeredTask.count }.by(0)
    end
  end

  describe "perform with scenario" do
    it "should create a triggered task with the provided params" do
      triggered_task_params = attributes_with_foreign_keys(:triggered_task, :scenario)
      home = Home.find(triggered_task_params[:home_id])
      create_triggered_task = CreateTriggeredTask.new(home: home, params: triggered_task_params)

      triggered_task = create_triggered_task.perform

      expect(triggered_task.delayed_job.cron).to eq(POLLING_RATE_CRON)
      expect(triggered_task.scenario.id).to eq(triggered_task_params[:scenario_id])
      expect(triggered_task.status_to_compare.symbolize_keys).to eq(triggered_task_params[:status_to_compare])
      expect(triggered_task.comparator).to eq(triggered_task_params[:comparator])
    end
  end
end
