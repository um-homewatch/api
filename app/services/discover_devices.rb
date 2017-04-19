class DiscoverDevices
  def initialize(home:, type:)
    @home = home
    @type = type
  end

  def perform
    uri = make_uri

    return false unless uri

    do_request(uri)
  end

  private

  attr_reader :home, :type

  def do_request(uri)
    HTTParty.get(uri,
      headers: { "Content-Type" => "application/json" },
      format: :json)
  end

  def make_uri
    base = uri_base
    home.tunnel + base + "/discover" if base
  end

  def uri_base
    case type
    when "light"
      "/lights"
    when "lock"
      "/locks"
    when "thermostat"
      "/thermostat"
    when "weather"
      "/weather"
    end
  end
end
