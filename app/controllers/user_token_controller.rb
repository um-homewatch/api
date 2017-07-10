# This controller allows the creation of tokens via user and password
# or with an already valid token
class UserTokenController < Knock::AuthTokenController
  include Knock::Authenticable
  before_action :authenticate_user, only: [:show]
  before_action :authenticate, only: [:create]

  def show
    render json: serialize_with_jwt(current_user)
  end

  def create
    render json: user_with_token, status: :created
  end

  private

  def serialize_with_jwt(user)
    UserSerializer.
      new(user).
      as_json.
      merge(jwt: token_for(user))
  end

  def token_for(user)
    Knock::AuthToken.new(payload: { sub: user.id }).token
  end

  def user_with_token
    serialized_user = UserSerializer.new(entity).attributes
    serialized_user.merge(jwt: auth_token.token)
  end
end
