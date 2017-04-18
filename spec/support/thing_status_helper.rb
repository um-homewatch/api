module ThingStatusHelper
  def stub_status!(thing, body)
    uri = thing.send(:uri)

    stub_request(:get, "#{uri}?address=#{thing.connection_info[:address]}&subType=#{thing.subtype}").
      with(headers: { "Content-Type" => "application/json" }).
      to_return(status: 200, body: body.to_json, headers: {})
  end

  def stub_send_status!(thing, body)
    uri = thing.send(:uri)

    stub_request(:put, "#{uri}?address=#{thing.connection_info[:address]}&subType=#{thing.subtype}").
      with(headers: { "Content-Type" => "application/json" }).
      to_return(status: 200, body: body.to_json, headers: {})
  end
end
