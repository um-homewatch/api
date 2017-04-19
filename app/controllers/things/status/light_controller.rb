class Things::Status::LightController < Things::StatusController
  private

  def fetch_thing
    home = current_user.homes.find(params[:home_id])
    home.things.find(params[:light_id])
  end

  def status_params
    params.require(:status).permit(:on)
  end
end
