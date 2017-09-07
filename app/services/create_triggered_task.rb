# Service object to create triggered tasks
class CreateTriggeredTask
  attr_reader :status

  def initialize(home:, params:)
    @home = home
    @params = params.clone
    @status = false
  end

  def perform
    perform_transaction

    triggered_task
  end

  private

  attr_reader :home, :params, :triggered_task

  def perform_transaction
    ActiveRecord::Base.transaction do
      @triggered_task = home.triggered_tasks.build(params)

      create_job

      raise ActiveRecord::Rollback if triggered_task.errors.count.positive?
    end
  end

  def create_job
    return unless triggered_task.save

    triggered_task.delayed_job = triggered_task.delay(cron: POLLING_RATE_CRON).apply_if

    @status = triggered_task.save
  end
end
