# Service object to discover devices
class DiscoverDevices
  def initialize(home:, params:)
    @home = home
    @params = params
  end

  def perform
    uri = make_uri

    return false unless uri

    do_request(uri)
  end

  private

  attr_reader :home, :params

  def do_request(uri)
    HTTParty.get(uri,
      headers: { "Content-Type" => "application/json" },
      query: params,
      format: :json)
  end

  def make_uri
    base = uri_base
    home.tunnel + base + "/discover" if base
  end

  def uri_base
    case params[:type]
    when "Things::Light"
      "/lights"
    when "Things::Lock"
      "/locks"
    when "Things::Thermostat"
      "/thermostat"
    when "Things::Weather"
      "/weather"
    end
  end
end
