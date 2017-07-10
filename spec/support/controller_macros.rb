require "active_model_serializers"

# This module contains several utilities to be used on testing
# It offers authentication methods for integration testing and
# serialization to JSON
module ControllerMacros
  def authenticate(user = nil)
    user ||= FactoryGirl.create(:user)
    request.headers["Authorization"] = token_for(user)
  end

  def serialize_to_json(resource, serializer: nil)
    serializer ||= serializer_for(resource)

    serializer.new(resource).to_json
  end

  def serialize_as_json(resource, serializer: nil)
    serializer ||= serializer_for(resource)

    serializer.new(resource).as_json
  end

  def parsed_response
    deep_symbolize JSON.parse(response.body)
  end

  private

  def token_for(user)
    Knock::AuthToken.new(payload: { sub: user.id }).token
  end

  def serializer_for(resource)
    ActiveModel::Serializer.serializer_for(resource)
  end

  def deep_symbolize(json)
    if json.is_a? Array
      json.map(&:deep_symbolize_keys)
    else
      json.deep_symbolize_keys
    end
  end
end
