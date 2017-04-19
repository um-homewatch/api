module HubApiHelper
  HEADERS = { "Content-Type" => "application/json" }.freeze

  def stub_status!(thing, body)
    uri = thing.send(:uri)

    stub_request(:get, "#{uri}?address=#{thing.connection_info[:address]}&subType=#{thing.subtype}").
      with(headers: HEADERS).
      to_return(status: 200, body: body.to_json, headers: HEADERS)
  end

  def stub_send_status!(thing, body)
    uri = thing.send(:uri)

    stub_request(:put, "#{uri}?address=#{thing.connection_info[:address]}&subType=#{thing.subtype}").
      with(body: stringify_values(body), headers: HEADERS).
      to_return(status: 200, body: body.to_json, headers: HEADERS)
  end

  def stub_discover!(home, uri, body)
    stub_request(:get, home.tunnel + uri).
      with(headers: HEADERS).
      to_return(status: 200, body: body.to_json, headers: HEADERS)
  end

  private

  def stringify_values(data)
    data.map do |k, v|
      [k.to_s, v.to_s]
    end.to_h
  end
end
