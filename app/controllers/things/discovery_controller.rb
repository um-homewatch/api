class Things::DiscoveryController < ApplicationController
  before_action :authenticate_user

  def index
    validate_params
    home = current_user.homes.find(params[:home_id])
    type = params[:type]

    response = DiscoverDevices.new(home: home, type: type).perform

    if response
      render json: response.body, status: response.code
    else
      head :bad_request
    end
  end

  private

  def validate_params
    head :bad_request unless params[:type]
  end
end
