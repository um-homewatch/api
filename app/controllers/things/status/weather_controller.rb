class Things::Status::WeatherController < Things::StatusController
  private

  def fetch_thing
    home = current_user.homes.find(params[:home_id])
    home.things.find(params[:weather_id])
  end
end
