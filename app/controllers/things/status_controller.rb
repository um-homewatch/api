# This controller allows the manipulation of the logged user thing status
class Things::StatusController < ApplicationController
  before_action :authenticate_user

  def show
    thing_status = fetch_thing.status

    render json: thing_status.body_json, status: normalize_status_code(thing_status.response_code)
  end

  def update
    thing = fetch_thing

    if thing.read_only?
      render json: { message: "Update not supported" }, status: :bad_request
    else
      thing_status = thing.send_status(filter_status_params(thing))

      render json: thing_status.body_json, status: normalize_status_code(thing_status.response_code)
    end
  end

  private

  def fetch_thing
    current_user.things.find(params[:thing_id])
  end

  def filter_status_params(thing)
    params.require(:status).permit(thing.allowed_params)
  end

  def normalize_status_code(status_code)
    return 404 unless status_code == 200
  end
end
