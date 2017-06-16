class SendStatusJob
  include ScheduledJob

  def initialize(thing, status)
    @thing = thing
    @status = status
  end

  def perform
    @thing.send_status(@status)
  end
end
