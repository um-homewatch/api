class Things::Light < Thing
  def allowed_params
    [:on]
  end

  def returned_params
    [:on]
  end

  private

  def uri
    home.tunnel + "/devices/lights"
  end
end
