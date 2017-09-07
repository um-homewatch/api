require "swagger_helper"

RSpec.describe "scenario_things", type: :request do
  let(:Authorization) { "Bearer nil" }
  let(:user) { create(:user) }
  let(:home_id) { create(:home, user: user).id }
  let(:thing_id) { create(:light, home_id: home_id).id }
  let(:scenario) { create(:scenario, home_id: home_id) }
  let(:scenario_id) { scenario.id }
  let(:id) { create(:scenario_thing, thing_id: thing_id, scenario_id: scenario_id).id }

  scenario_thing_response_schema = {
    "$ref": "#/definitions/ScenarioThing",
  }

  scenario_thing_array_schema = {
    type: :array,
    items: scenario_thing_response_schema.deep_dup,
  }

  scenario_thing_params_schema = {
    properties: {
      scenario_thing: {
        type: :object,
        properties: {
          thing_id: { type: :integer },
          status: { type: :object },
        },
      },
    },
  }

  path "/scenarios/{scenario_id}/things", tags: ["Scenario Things"] do
    parameter "Authorization", required: true, in: :header, type: :string, description: "auth token"
    parameter "scenario_id", in: :path, type: :string

    get(summary: "list scenario_things") do
      response(200, description: "successful", schema: scenario_thing_array_schema) do
        let(:Authorization) { "Bearer #{token_for(user)}" }
      end

      response(401, description: "not authenticated")
    end

    post(summary: "create scenario_thing") do
      consumes "application/json"
      parameter "body", in: :body, required: true, schema: scenario_thing_params_schema, description: "thing to create"

      response(201, description: "successful", schema: scenario_thing_response_schema) do
        let(:Authorization) { "Bearer #{token_for(user)}" }
        let(:body) { { scenario_thing: attributes_for(:scenario_thing, thing_id: thing_id) } }
      end

      response(400, description: "bad request") do
        let(:Authorization) { "Bearer #{token_for(user)}" }
      end

      response(401, description: "not authenticated")
    end
  end

  path "/scenarios/{scenario_id}/things/{id}", tags: ["Scenario Things"] do
    parameter "Authorization", required: true, in: :header, type: :string, description: "auth token"
    parameter "scenario_id", in: :path, type: :string
    parameter "id", in: :path, type: :string

    get(summary: "show scenario_thing") do
      response(200, description: "successful", schema: scenario_thing_response_schema) do
        let(:Authorization) { "Bearer #{token_for(user)}" }
      end

      response(401, description: "not authenticated")
    end

    patch(summary: "update scenario_thing") do
      consumes "application/json"
      parameter "body", in: :body, required: true, schema: scenario_thing_params_schema, description: "scenario thing to create"

      response(200, description: "successful", schema: scenario_thing_response_schema) do
        let(:Authorization) { "Bearer #{token_for(user)}" }
        let(:body) { { scenario_thing: attributes_for(:scenario_thing, scenario: scenario) } }
      end

      response(400, description: "bad request") do
        let(:Authorization) { "Bearer #{token_for(user)}" }
      end

      response(401, description: "not authenticated")
    end

    put(summary: "update scenario_thing") do
      consumes "application/json"
      parameter "body", in: :body, required: true, schema: scenario_thing_params_schema, description: "scenario thing to create"

      response(200, description: "successful", schema: scenario_thing_response_schema) do
        let(:Authorization) { "Bearer #{token_for(user)}" }
        let(:body) { { scenario_thing: attributes_for(:scenario_thing, scenario: scenario) } }
      end

      response(400, description: "bad request") do
        let(:Authorization) { "Bearer #{token_for(user)}" }
      end

      response(401, description: "not authenticated")
    end

    delete(summary: "delete scenario_thing") do
      response(204, description: "successful") do
        let(:Authorization) { "Bearer #{token_for(user)}" }
      end

      response(401, description: "not authenticated")
    end
  end
end
