class ScenarioApplyController < ApplicationController
  before_action :authenticate_user

  def create
    scenario = current_user.scenarios.find(params[:scenario_id])

    scenario.delay.apply

    head :ok
  end
end
