class ThingSerializer < ActiveModel::Serializer
  attributes :id, :type, :subtype, :connection_info
end
