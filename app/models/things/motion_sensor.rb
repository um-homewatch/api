# This class is responsible for representing devices of type "motion sensor"
class Things::MotionSensor < Thing
  def returned_params
    [:movement]
  end

  private

  def route
    "/devices/motionsensors".freeze
  end
end
