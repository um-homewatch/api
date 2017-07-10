# Serializer for triggered task objects
class TriggeredTaskSerializer < OmmitNilSerializer
  attributes :id, :status_to_compare, :status_to_apply, :comparator

  has_one :thing
  has_one :thing_to_compare
  has_one :scenario
end
