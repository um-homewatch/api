class Things::WeathersController < ThingsController
  before_action :authenticate_user

  def create
    home = current_user.homes.find(params[:home_id])
    thing = home.weathers.build(thing_params)

    if thing.save
      render json: thing, status: :created
    else
      render json: thing.errors, status: :unprocessable_entity
    end
  end

  private

  def thing_params
    thing_params = params.require(:weather).permit(:id, :home_id, :subtype)
    thing_params[:connection_info] = params[:weather][:connection_info]
    thing_params.permit!
  end
end
