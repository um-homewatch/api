class Things::Weather < Thing
  private

  def uri
    home.tunnel + "/weather"
  end
end
