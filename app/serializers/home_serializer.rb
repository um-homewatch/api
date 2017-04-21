class HomeSerializer < ActiveModel::Serializer
  attributes :id, :name, :location, :ip_address

  has_many :scenarios
end
