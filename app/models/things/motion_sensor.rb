class Things::MotionSensor < Thing
  def allowed_params
    [:movement]
  end

  private

  def uri
    home.tunnel + "/devices/motionsensors"
  end
end
