# This module is responsible for stubbing api calls to the homewatch hub
module HubApiHelper
  HEADERS = { "Content-Type" => "application/json" }.freeze

  def stub_status!(thing, body, status_code: 200)
    uri = thing.send(:uri)

    stub_request(:get, "#{uri}?address=#{thing.connection_info[:address]}&subtype=#{thing.subtype}").
      with(headers: HEADERS).
      to_return(status: status_code, body: body.to_json, headers: HEADERS)
  end

  def stub_send_status!(thing, body, stringify = nil, status_code: 200)
    uri = thing.send(:uri)

    stub_request(:put, "#{uri}?address=#{thing.connection_info[:address]}&subtype=#{thing.subtype}").
      with(body: (stringify ? stringify_hash(body) : body), headers: HEADERS).
      to_return(status: status_code, body: body.to_json, headers: HEADERS)
  end

  def stub_discover!(home, uri, body, status_code: 200)
    stub_request(:get, home.tunnel + uri).
      with(headers: HEADERS).
      to_return(status: status_code, body: body.to_json, headers: HEADERS)
  end

  private

  def stringify_hash(data)
    data.map do |key, value|
      [key.to_s, value.to_s]
    end.to_h
  end
end
