# Serializer for scenario objects
class ScenarioSerializer < ActiveModel::Serializer
  attributes :id, :name

  has_many :scenario_things
end
