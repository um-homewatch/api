class Things::DiscoveryController < ApplicationController
  def index
    validate_params
    home = Home.find(params[:home_id])
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
