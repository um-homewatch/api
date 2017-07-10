# This controller allows the manipulation of the logged user thing status
class Things::StatusController < ApplicationController
  before_action :authenticate_user

  def show
    thing_status = fetch_thing.status

    render json: thing_status, status: thing_status.code
  end

  def update
    thing = fetch_thing
    thing_status_params = filter_status_params(thing)

    if thing_status_params.empty?
      render json: { message: "Update not supported" }, status: :bad_request
    else
      thing_status = thing.send_status(thing_status_params)

      render json: thing_status, status: thing_status.code
    end
  end

  private

  def fetch_thing
    current_user.things.find(params[:thing_id])
  end

  def filter_status_params(thing)
    params.require(:status).permit(thing.allowed_params)
  end
end
