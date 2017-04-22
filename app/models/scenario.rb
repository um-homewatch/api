class Scenario < ApplicationRecord
  belongs_to :home
  has_many :scenario_things

  validates :name, presence: true

  def apply
    scenario_things.map(&:apply).all?
  end
end
