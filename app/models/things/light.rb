class Things::Light < Thing
  def status
    HTTParty.get(uri,
      headers: { "Content-Type" => "application/json" },
      query: connection_info)
  end

  def send_status(status)
    HTTParty.put(uri,
      headers: { "Content-Type" => "application/json" },
      query: connection_info,
      body: status.to_json)
  end

  private

  def uri
    home.tunnel + "/lights"
  end
end
