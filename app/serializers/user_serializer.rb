# Serializer for user objects
class UserSerializer < ActiveModel::Serializer
  attributes :id, :name, :email
end
