class UserTokenController < Knock::AuthTokenController
  def create
    render json: user_with_token, status: :created
  end

  private

  def user_with_token
    serialized_user = UserSerializer.new(entity).attributes
    serialized_user.merge(jwt: auth_token.token)
  end
end
