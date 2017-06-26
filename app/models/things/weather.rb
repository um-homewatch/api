class Things::Weather < Thing
  def allowed_params
    []
  end

  private

  def uri
    home.tunnel + "/devices/weather"
  end
end
