module Curl
  class Easy
    def body_json
      JSON.parse(body_str)
    rescue JSON::ParserError => e
      return {}
    end
  end
end
