# Abstract serializer that ommits nil values
class OmmitNilSerializer < ActiveModel::Serializer
  def serializable_hash(*args)
    super.compact
  end
end
