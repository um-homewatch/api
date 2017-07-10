# This class represents the scenario thing model
# It belongs to a scenario and a thing. It contains a status
# that can be applied to the thing associated with this object
class ScenarioThing < ApplicationRecord
  belongs_to :scenario
  belongs_to :thing

  validates :thing_id, :scenario_id, :status, presence: true
  validates :thing_id, uniqueness: { scope: :scenario_id }
  validate :thing_must_belong_to_home

  def apply
    thing.send_status(status).code == 200
  end

  def home
    scenario.home
  end

  def status
    self[:status].symbolize_keys
  end

  private

  def thing_must_belong_to_home
    return if scenario && thing && scenario.home == thing.home

    errors.add(:thing_id, "thing must belong to the scenario's home")
  end
end
