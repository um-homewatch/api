# This class is responsible for representing devices of type "thermostat"
class Things::Thermostat < Thing
  def allowed_params
    [:targetTemperature]
  end

  def returned_params
    [:targetTemperature]
  end

  def self.route
    "/devices/thermostats".freeze
  end
end
