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

  def create
    home = Home.find(params[:home_id])
    thing = home.things.build(thing_params)

    if thing.save
      render json: thing, status: :created
    else
      render json: thing.errors, status: :unprocessable_entity
    end
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
    thing_params = params.require(:thing).permit(:id, :home_id, :type, :subtype)
    thing_params[:payload] = params[:thing][:payload]
    thing_params.permit!
  end
end
