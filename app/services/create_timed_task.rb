class CreateTimedTask
  attr_reader :status

  def initialize(home:, params:)
    @home = home
    @params = params.clone
    @cron = @params.delete(:cron)
    @status = false
  end

  def perform
    @timed_task = home.timed_tasks.build(params)

    ActiveRecord::Base.transaction do
      create_job

      raise ActiveRecord::Rollback if timed_task.errors.count.positive?
    end

    timed_task
  end

  private

  attr_reader :home, :params, :cron, :timed_task

  def create_job
    timed_task.delayed_job = timed_task.thing.delay(cron: cron).send_status(timed_task.status)

    @status = timed_task.save
  end
end
