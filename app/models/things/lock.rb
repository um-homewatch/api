class Things::Lock < Thing
  def allowed_params
    [:locked]
  end

  def returned_params
    [:locked]
  end

  private

  def uri
    home.tunnel + "/devices/locks"
  end
end
