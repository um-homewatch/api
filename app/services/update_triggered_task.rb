# Service object to update triggered tasks
class UpdateTriggeredTask
  attr_reader :status

  def initialize(triggered_task:, params:)
    @triggered_task = triggered_task
    @params = params.clone
    @status = false
  end

  def perform
    ActiveRecord::Base.transaction do
      delete_old_job

      update_triggered_task

      raise ActiveRecord::Rollback if triggered_task.errors.count.positive?
    end

    triggered_task
  end

  private

  attr_reader :triggered_task, :cron, :params

  def delete_old_job
    triggered_task.delayed_job.destroy if triggered_task.delayed_job
  end

  def update_triggered_task
    triggered_task.update(params)

    triggered_task.delayed_job = triggered_task.delay(cron: POLLING_RATE_CRON).apply_if

    @status = triggered_task.save
  end
end
