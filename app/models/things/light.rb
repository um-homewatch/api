class Things::Light < Thing
  def allowed_params
    [:on]
  end

  private

  def uri
    home.tunnel + "/lights"
  end
end
