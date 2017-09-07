# This class is responsible for representing devices of type "motion sensor"
class Things::MotionSensor < Thing
  def returned_params
    [:movement].freeze
  end

  def self.route
    "/devices/motionsensors".freeze
  end
end
