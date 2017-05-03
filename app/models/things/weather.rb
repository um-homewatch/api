class Things::Weather < Thing
  def allowed_params
    []
  end

  private

  def uri
    home.tunnel + "/weather"
  end
end
