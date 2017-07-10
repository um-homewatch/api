# This class represents the scenario model, a group of statuses to be applied to things
# It belongs to a home and therefore to a user. It is also composed of various scenario_things
class Scenario < ApplicationRecord
  belongs_to :home
  has_many :scenario_things

  validates :name, presence: true

  def apply
    scenario_things.map(&:apply).all?
  end
end
