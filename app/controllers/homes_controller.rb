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
    home = current_user.homes.build(home_params)

    if home.save
      render json: home, status: :created
    else
      render json: home.errors, status: :unprocessable_entity
    end
  end

  def update
    home = current_user.homes.find(params[:id])

    if home.update(home_params)
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
    params.require(:home).permit(:name, :location).merge(ip_address: request.ip)
  end
end
