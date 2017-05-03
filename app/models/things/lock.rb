class Things::Lock < Thing
  def allowed_params
    [:locked]
  end

  private

  def uri
    home.tunnel + "/locks"
  end
end
