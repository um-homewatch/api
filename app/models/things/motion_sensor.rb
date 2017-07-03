class Things::MotionSensor < Thing
  def returned_params
    [:movement]
  end

  private

  def uri
    home.tunnel + "/devices/motionsensors"
  end
end
