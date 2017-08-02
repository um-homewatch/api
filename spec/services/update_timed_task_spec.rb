require "rails_helper"

describe UpdateTimedTask do
  let(:timed_task) { create(:timed_task) }
  let(:params) do
    attributes_for(
      :timed_task,
      thing_id: create(:light, home: timed_task.home).id,
      cron: "10 * * * *",
    )
  end

  describe "perform" do
    it "should set status to true if updated" do
      update_timed_task = UpdateTimedTask.new(timed_task: timed_task, params: params)

      update_timed_task.perform

      expect(update_timed_task).to be_truthy
    end

    it "should create a timed task with the provided params" do
      update_timed_task = UpdateTimedTask.new(timed_task: timed_task, params: params)

      timed_task = update_timed_task.perform

      expect(timed_task.thing.id).to eq(params[:thing_id])
      expect(timed_task.delayed_job.cron).to eq(params[:cron])
      expect(timed_task.status_to_apply.symbolize_keys).to eq(params[:status_to_apply])
    end

    it "should set status to false if it fails" do
      params[:thing] = create(:light)
      update_timed_task = UpdateTimedTask.new(timed_task: timed_task, params: params)

      # should fail the 'thing belongs to home' validation
      update_timed_task.perform

      expect(update_timed_task.status).to be_falsy
    end
  end
end
