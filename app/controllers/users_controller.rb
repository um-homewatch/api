class UsersController < ApplicationController
  def create
    user = User.new(user_params)

    if user.save
      render json: serialize_with_jwt(user)
    else
      render json: { errors: user.errors }, status: :unprocessable_entity
    end
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

  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end
end
