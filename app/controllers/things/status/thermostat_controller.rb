class Things::Status::ThermostatController < Things::StatusController
  private

  def fetch_thing
    home = current_user.homes.find(params[:home_id])
    home.things.find(params[:thermostat_id])
  end

  def status_params
    params.require(:status).permit(:targetTemperature)
  end
end
