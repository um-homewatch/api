# This controller allows the manipulation of the logged user's scenario things
class ScenarioThingsController < ApplicationController
  before_action :authenticate_user

  def index
    scenario = fetch_scenario

    render json: scenario.scenario_things
  end

  def show
    scenario_thing = fetch_scenario.scenario_things.find(params[:id])

    render json: scenario_thing
  end

  def create
    scenario_thing = fetch_scenario.scenario_things.build(scenario_thing_params)

    if scenario_thing.save
      render json: scenario_thing, status: :created
    else
      render json: scenario_thing.errors, status: :unprocessable_entity
    end
  end

  def update
    scenario_thing = fetch_scenario.scenario_things.find(params[:id])

    if scenario_thing.update(scenario_thing_params)
      render json: scenario_thing
    else
      render json: scenario_thing.errors, status: :unprocessable_entity
    end
  end

  def destroy
    scenario_thing = fetch_scenario.scenario_things.find(params[:id])

    scenario_thing.destroy
  end

  private

  def fetch_scenario
    current_user.scenarios.find(params[:scenario_id])
  end

  def scenario_thing_params
    scenario_thing_params = params.require(:scenario_thing).permit(:thing_id)
    scenario_thing_params[:status] = params[:scenario_thing][:status].transform_keys(&:to_sym).permit!
    scenario_thing_params
  end
end
