class Things::Lock < Thing
  private

  def uri
    home.tunnel + "/locks"
  end
end
