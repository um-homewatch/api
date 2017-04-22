class ThingsController < ApplicationController
  before_action :authenticate_user

  def index
    home = current_user.homes.find(params[:home_id])
    things = home.things

    render json: things
  end

  def show
    home = current_user.homes.find(params[:home_id])
    thing = home.things.find(params[:id])

    render json: thing
  end

  def update
    home = current_user.homes.find(params[:home_id])
    thing = home.things.find(params[:id])

    if thing.update(thing_params)
      render json: thing
    else
      render json: thing.errors, status: :unprocessable_entity
    end
  end

  def destroy
    home = current_user.homes.find(params[:home_id])
    thing = home.things.find(params[:id])

    thing.destroy
  end

  protected

  def thing_params
    # ...
  end
end
