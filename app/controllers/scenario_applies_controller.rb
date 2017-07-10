# This controller allows an authenticated user to apply a given scenario
class ScenarioAppliesController < ApplicationController
  before_action :authenticate_user

  def create
    scenario = current_user.scenarios.find(params[:scenario_id])

    scenario.delay.apply

    head :ok
  end
end
