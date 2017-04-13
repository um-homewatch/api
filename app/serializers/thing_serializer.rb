class ThingSerializer < ActiveModel::Serializer
  attributes :id, :type, :subtype, :payload
end
