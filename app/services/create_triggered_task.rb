# Service object to create triggered tasks
class CreateTriggeredTask
  attr_reader :status

  def initialize(home:, params:)
    @home = home
    @params = params.clone
    @status = false
  end

  def perform
    @triggered_task = home.triggered_tasks.build(params)

    ActiveRecord::Base.transaction do
      create_job

      raise ActiveRecord::Rollback if triggered_task.errors.count.positive?
    end

    triggered_task
  end

  private

  attr_reader :home, :params, :triggered_task

  def create_job
    return unless triggered_task.save

    triggered_task.delayed_job = triggered_task.delay(cron: POLLING_RATE_CRON).apply_if

    @status = triggered_task.save
  end
end
