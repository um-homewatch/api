class Things::Thermostat < Thing
  private

  def uri
    home.tunnel + "/thermostats"
  end
end
