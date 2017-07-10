# Serializer for scenario things objects
class ScenarioThingSerializer < ActiveModel::Serializer
  attributes :id, :status
  has_one :thing
end
