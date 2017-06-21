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
    return unless timed_task.save

    timed_task.delayed_job = timed_task.delay(cron: cron).apply

    @status = timed_task.save
  end
end
