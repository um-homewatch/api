class Things::LocksController < ThingsController
  before_action :authenticate_user

  def create
    home = Home.find(params[:home_id])
    thing = home.locks.build(thing_params)

    if thing.save
      render json: thing, status: :created
    else
      render json: thing.errors, status: :unprocessable_entity
    end
  end

  private

  def thing_params
    thing_params = params.require(:lock).permit(:id, :home_id, :subtype)
    thing_params[:connection_info] = params[:lock][:connection_info]
    thing_params.permit!
  end
end
