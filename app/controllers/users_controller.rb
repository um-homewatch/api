# This controller allows the creation of users, and the rendering and update
# of the user currently logged in (via JWT token)
class UsersController < ApplicationController
  before_action :authenticate_user, except: [:create]

  def show
    render json: current_user
  end

  def create
    user = User.new(user_params)

    if user.save
      render json: serialize_with_jwt(user), status: :created
    else
      render json: { errors: user.errors }, status: :unprocessable_entity
    end
  end

  def update
    if current_user.update(user_params)
      render json: serialize_with_jwt(current_user)
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
