# This class is responsible for handling real time
# ting status updates
class ThingStatusChannel < ApplicationCable::Channel
  def subscribed
    thing = Thing.find(params[:data][:thing_id])

    stream_from "thing_#{thing.id}"
  end

  def fetch_status
    thing = Thing.find(params[:data][:thing_id])

    return unless thing

    thing.broadcast_status
  end
end
