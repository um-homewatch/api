class ApplyScenarioJob < ApplicationJob
  queue_as :default

  def perform(scenario)
    scenario.apply
  end
end
