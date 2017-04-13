class ThingSerializer < ActiveModel::Serializer
  attributes :id, :kind, :subtype, :payload
end
