class ScenarioThing < ApplicationRecord
  belongs_to :scenario
  belongs_to :thing

  validates :thing_id, uniqueness: { scope: :scenario_id }

  def apply
    thing.send_status(status).code == 200
  end

  def status
    self[:status]&.symbolize_keys
  end
end
