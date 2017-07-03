class Things::Weather < Thing
  def returned_params
    [:temperature, :windSpeed, :raining, :cloudy]
  end

  private

  def uri
    home.tunnel + "/devices/weather"
  end
end
