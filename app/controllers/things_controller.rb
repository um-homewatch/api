class ThingsController < ApplicationController
  before_action :authenticate_user

  def index
    home = Home.find(params[:home_id])
    things = home.things

    render json: things
  end

  def show
    home = Home.find(params[:home_id])
    thing = home.things.find(params[:id])

    render json: thing
  end

  def update
    home = Home.find(params[:home_id])
    thing = home.things.find(params[:id])

    if thing.update(thing_params)
      render json: thing
    else
      render json: thing.errors, status: :unprocessable_entity
    end
  end

  def destroy
    home = Home.find(params[:home_id])
    thing = home.things.find(params[:id])

    thing.destroy
  end

  private

  def thing_params
    thing_params = params.require(:thing).permit(:id, :home_id, :subtype)
    thing_params[:connection_info] = params[:thing][:connection_info].symbolize_keys
    thing_params.permit!
  end
end
