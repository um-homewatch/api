require "swagger_helper"

RSpec.describe "things/discovery", type: :request do
  let(:Authorization) { "Bearer nil" }
  let(:user) { create(:user) }
  let(:home) { create(:home, user: user) }
  let(:home_id) { home.id }
  let(:devices) { [{ address: 123 }, { address: 321 }] }

  discovered_items_schema = {
    type: :array,
    items: {
      type: :object,
      properties: {
        address: { type: :string, format: :uri },
        port: { type: :integer },
        subtype: { type: :string },
        type: { type: :string, enum: Thing.types },
      },
    },
  }

  path "/homes/{home_id}/things/discovery", tags: ["Things Discovery"] do
    parameter "Authorization", required: true, in: :header, type: :string, description: "auth token"
    parameter "home_id", required: true, in: :path, type: :string
    parameter "type", required: true, in: :query, type: :string, enum: Thing.types
    parameter "subtype", required: true, in: :query, type: :string
    parameter "port", in: :query, type: :integer

    let(:type) { "Things::Light" }
    let(:subtype) { "rest" }

    get(summary: "list discoveries") do
      response(200, description: "successful", schema: discovered_items_schema) do
        let(:Authorization) { "Bearer #{token_for(user)}" }

        before { stub_discover!(home, "/devices/lights/discover?subtype=#{subtype}", devices) }
      end

      response(400, description: "bad request") do
        let(:Authorization) { "Bearer #{token_for(user)}" }
        let(:type) { nil }
      end

      response(401, description: "not authenticated")
    end
  end
end
