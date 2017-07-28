# This controller allows the logged user to discover devices in his home
class Things::DiscoveryController < ApplicationController
  before_action :authenticate_user

  def index
    home = current_user.homes.find(params[:home_id])
    response = DiscoverDevices.new(home: home, params: discovery_params.to_h).perform

    if response
      render json: response.body_json, status: response.response_code
    else
      head :bad_request
    end
  end

  private

  def discovery_params
    params.permit(:type, :subtype, :port)
  end
end
