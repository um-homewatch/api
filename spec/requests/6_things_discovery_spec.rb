require "swagger_helper"

RSpec.describe "things/discovery", type: :request do
  let(:Authorization) { "Bearer nil" }
  let(:user) { create(:user) }
  let(:home) { create(:home, user: user) }
  let(:home_id) { home.id }
  let(:devices) { [{ address: 123 }, { address: 321 }] }

  path "/homes/{home_id}/things/discovery", tags: ["Things Discovery"] do
    parameter "Authorization", required: true, in: :header, type: :string, description: "auth token"
    parameter "home_id", required: true, in: :path, type: :string
    parameter "type", required: true, in: :query, type: :string, enum: Thing.types
    parameter "subtype", required: true, in: :query, type: :string

    let(:type) { "Things::Light" }
    let(:subtype) { "rest" }

    get(summary: "list discoveries") do
      response(200, description: "successful") do
        let(:Authorization) { "Bearer #{token_for(user)}" }

        before { stub_discover!(home, "/lights/discover?subtype=#{subtype}", devices) }
      end

      response(400, description: "bad request") do
        let(:Authorization) { "Bearer #{token_for(user)}" }
        let(:type) { nil }
      end

      response(401, description: "not authenticated")
    end
  end
end
