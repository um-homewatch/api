class Things::StatusController < ApplicationController
  def show
    thing_status = fetch_thing.status

    render json: thing_status, status: thing_status.code
  end

  def update
    thing_status = fetch_thing.send_status(status_params)

    render json: thing_status, status: thing_status.code
  end

  protected

  def fetch_thing
    # ...
  end

  def status_params
    # ...
  end
end
