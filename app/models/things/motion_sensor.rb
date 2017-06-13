class Things::MotionSensor < Thing
  def allowed_params
    [:movement]
  end

  private

  def uri
    home.tunnel + "/motionsensors"
  end
end
