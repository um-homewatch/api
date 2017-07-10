# This controller allows the manipulation of the logged user's scenarios
class ScenariosController < ApplicationController
  before_action :authenticate_user

  def index
    home = current_user.homes.find(params[:home_id])

    render json: home.scenarios
  end

  def show
    scenario = current_user.scenarios.find(params[:id])

    render json: scenario
  end

  def create
    home = current_user.homes.find(params[:home_id])
    scenario = home.scenarios.build(scenario_params)

    if scenario.save
      render json: scenario, status: :created
    else
      render json: scenario.errors, status: :unprocessable_entity
    end
  end

  def update
    scenario = current_user.scenarios.find(params[:id])

    if scenario.update(scenario_params)
      render json: scenario
    else
      render json: scenario.errors, status: :unprocessable_entity
    end
  end

  def destroy
    scenario = current_user.scenarios.find(params[:id])

    scenario.destroy
  end

  private

  def scenario_params
    params.require(:scenario).permit(:name)
  end
end
