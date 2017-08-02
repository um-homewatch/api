# This class represents the timed task model, a task that is applied on a given schedule
class Tasks::TimedTask < ApplicationRecord
  include Task

  def cron
    delayed_job&.cron
  end
end
