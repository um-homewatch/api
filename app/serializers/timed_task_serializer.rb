# Serializer for timed tasks objects
class TimedTaskSerializer < OmmitNilSerializer
  attributes :id, :status_to_apply, :cron, :next_run

  has_one :thing
  has_one :scenario

  def next_run
    object.delayed_job.run_at
  end
end
