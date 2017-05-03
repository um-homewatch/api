class Things::StatusController < ApplicationController
  def show
    thing_status = fetch_thing.status

    render json: thing_status, status: thing_status.code
  end

  def update
    thing = fetch_thing
    thing_status = thing.send_status(status_params(thing))

    render json: thing_status, status: thing_status.code
  end

  protected

  def fetch_thing
    current_user.things.find(params[:thing_id])
  end

  def status_params(thing)
    params.require(:status).permit(thing.allowed_params)
  end
end
