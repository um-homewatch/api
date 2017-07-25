# This class represents the timed task model, a task that is applied on a given schedule
class Tasks::TimedTask < ApplicationRecord
  include Task

  validate :status_params_equals_thing_params

  def status
    self[:status].symbolize_keys if self[:status]
  end

  def cron
    delayed_job&.cron
  end

  private

  def status_params_equals_thing_params
    return unless thing && status && status.keys != thing.allowed_params

    errors.add(:status, "not a valid status for this thing type")
  end
end
