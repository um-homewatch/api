# This controller allows the manipulation of the logged user's homes
class HomesController < ApplicationController
  before_action :authenticate_user

  def index
    homes = current_user.homes

    render json: homes
  end

  def show
    home = current_user.homes.find(params[:id])

    render json: home
  end

  def create
    create_home_service = CreateHome.new(user: current_user, params: home_params)
    home = create_home_service.perform

    if create_home_service.status
      render json: home, status: :created
    else
      render json: home.errors, status: :unprocessable_entity
    end
  end

  def update
    home = current_user.homes.find(params[:id])
    update_home_service = UpdateHome.new(home: home, params: home_params)

    home = update_home_service.perform

    if update_home_service.status
      render json: home
    else
      render json: home.errors, status: :unprocessable_entity
    end
  end

  def destroy
    home = current_user.homes.find(params[:id])

    home.destroy
  end

  private

  def home_params
    params.require(:home).permit(:name, :location, :tunnel).merge(ip_address: request.ip)
  end
end
