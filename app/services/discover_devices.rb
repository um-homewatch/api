# Service object to discover devices
class DiscoverDevices
  attr_reader :status

  def initialize(home:, params:)
    @home = home
    @params = params
    @status = false
  end

  def perform
    uri = make_uri

    return do_request(uri) if status
  end

  private

  attr_reader :home, :params
  attr_writer :status

  def do_request(uri)
    Curl.get(uri + "?" + params.to_query) do |http|
      http.headers["Content-Type"] = "application/json"
      http.headers["Authorization"] = home.token
    end
  end

  def make_uri
    base = uri_base

    return unless base

    @status = true
    home.tunnel + base + "/discover"
  end

  def uri_base
    type = params.delete(:type)
    return unless Thing.types.include?(type)

    type.constantize.route
  end
end
