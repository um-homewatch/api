# This class is responsible for representing devices of type "weather"
class Things::Weather < Thing
  def returned_params
    [:temperature, :windSpeed, :raining, :cloudy].freeze
  end

  def self.route
    "/devices/weather".freeze
  end
end
