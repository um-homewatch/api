class Things::Thermostat < Thing
  def allowed_params
    [:targetTemperature]
  end

  private

  def uri
    home.tunnel + "/devices/thermostats"
  end
end
