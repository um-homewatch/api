# Serializer for home objects
class HomeSerializer < ActiveModel::Serializer
  attributes :id, :name, :tunnel, :location, :ip_address
end
