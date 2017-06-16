class CreateTimedTask
  attr_reader :status

  def initialize(home:, params:)
    @home = home
    @params = params
    @status = false
  end

  def perform
    cron = params.delete(:cron)
    return unless cron

    timed_task = home.timed_tasks.build(params)

    ActiveRecord::Base.transaction do
      timed_task.delayed_job = timed_task.thing.delay(cron: cron).send_status(timed_task.status)

      timed_task.save
    end

    timed_task
  end

  private

  attr_reader :home, :params
end
