require "rails_helper"

RSpec.describe "things/status", type: :request do
  let(:Authorization) { "Bearer nil" }
  let(:user) { create(:user) }
  let(:home_id) { create(:home, user: user).id }
  let(:thing) { create(:light, home_id: home_id) }
  let(:thing_id) { thing.id }
  let(:thing_status) { { on: true } }

  status_schema = {
    properties: {
      status: {
        type: :object,
      },
    },
  }

  path "/things/{thing_id}/status", tags: ["Thing Status"] do
    parameter "Authorization", required: true, in: :header, type: :string, description: "auth token"
    parameter "thing_id", in: :path, type: :string

    get(summary: "show status", schema: status_schema) do
      response(200, description: "successful") do
        let(:Authorization) { "Bearer #{token_for(user)}" }

        before { stub_status!(thing, thing_status) }
      end

      response(401, description: "not authenticated")
    end

    patch(summary: "update status") do
      consumes "application/json"
      parameter "body", in: :body, required: true, schema: status_schema, description: "status to apply"

      response(200, description: "successful", schema: status_schema) do
        let(:Authorization) { "Bearer #{token_for(user)}" }
        let(:body) { { status: thing_status } }
        before { stub_send_status!(thing, thing_status) }
      end

      response(400, description: "bad request") do
        let(:Authorization) { "Bearer #{token_for(user)}" }
      end

      response(401, description: "not authenticated")
    end

    put(summary: "update status") do
      consumes "application/json"
      parameter "body", in: :body, required: true, schema: status_schema, description: "status to apply"

      response(200, description: "successful", schema: status_schema) do
        let(:Authorization) { "Bearer #{token_for(user)}" }
        let(:body) { { status: thing_status } }
        before { stub_send_status!(thing, thing_status) }
      end

      response(400, description: "bad request") do
        let(:Authorization) { "Bearer #{token_for(user)}" }
      end

      response(401, description: "not authenticated")
    end
  end
end
