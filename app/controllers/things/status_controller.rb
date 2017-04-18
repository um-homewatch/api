class Things::StatusController < ApplicationController
  def show
    thing = fetch_thing

    render json: thing.status
  end

  def update
    thing = fetch_thing

    render json: thing.send_status(status_params)
  end

  protected

  def fetch_thing
    # ...
  end

  def status_params
    # ...
  end
end
