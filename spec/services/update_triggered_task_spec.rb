require "rails_helper"

describe UpdateTriggeredTask do
  let(:triggered_task) { create(:triggered_task) }
  let(:params) do
    attributes_for(
      :triggered_task,
      thing_id: create(:light, home: triggered_task.home).id,
      thing_to_compare_id: create(:light, home: triggered_task.home).id,
    )
  end

  describe "perform" do
    it "should set status to true if updated" do
      update_triggered_task = UpdateTriggeredTask.new(triggered_task: triggered_task, params: params)

      update_triggered_task.perform

      expect(update_triggered_task).to be_truthy
    end

    it "should create a triggered task with the provided params" do
      update_triggered_task = UpdateTriggeredTask.new(triggered_task: triggered_task, params: params)

      triggered_task = update_triggered_task.perform

      expect(triggered_task.thing_to_compare.id).to eq(params[:thing_to_compare_id])
      expect(triggered_task.thing.id).to eq(params[:thing_id])
      expect(triggered_task.delayed_job.cron).to eq(POLLING_RATE_CRON)
      expect(triggered_task.status_to_apply.symbolize_keys).to eq(params[:status_to_apply])
      expect(triggered_task.status_to_compare.symbolize_keys).to eq(params[:status_to_compare])
      expect(triggered_task.comparator).to eq(params[:comparator])
    end

    it "should set status to false if it fails" do
      params[:thing] = create(:light)
      update_triggered_task = UpdateTriggeredTask.new(triggered_task: triggered_task, params: params)

      # should fail the 'thing belongs to home' validation
      update_triggered_task.perform

      expect(update_triggered_task.status).to be_falsy
    end
  end
end
