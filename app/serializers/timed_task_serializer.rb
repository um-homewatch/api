class TimedTaskSerializer < OmmitNilSerializer
  attributes :id, :status, :cron
  has_one :thing
  has_one :scenario
end
