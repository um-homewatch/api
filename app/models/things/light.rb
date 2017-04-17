class Things::Light < Thing
  private

  def uri
    home.tunnel + "/lights"
  end
end
