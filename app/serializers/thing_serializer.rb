# Serializer for thing objects
class ThingSerializer < ActiveModel::Serializer
  attributes :id, :name, :type, :subtype, :connection_info
end
