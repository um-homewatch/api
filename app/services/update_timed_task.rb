# Service object to update timed tasks
class UpdateTimedTask
  attr_reader :status

  def initialize(timed_task:, params:)
    @timed_task = timed_task
    @params = params.clone
    @cron = @params.delete(:cron)
    @status = false
  end

  def perform
    ActiveRecord::Base.transaction do
      delete_old_job

      update_timed_task
    end

    timed_task
  end

  private

  attr_reader :timed_task, :cron, :params

  def delete_old_job
    timed_task.delayed_job.destroy
  end

  def update_timed_task
    timed_task.update(params)

    timed_task.delayed_job = timed_task.delay(cron: cron).apply

    @status = timed_task.save
  end
end
