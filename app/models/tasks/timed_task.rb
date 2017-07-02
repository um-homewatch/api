class Tasks::TimedTask < ApplicationRecord
  include Task  

  def cron
    delayed_job&.cron
  end
end
