require "swagger_helper"

RSpec.describe "scenarios", type: :request do
  let(:Authorization) { "Bearer nil" }
  let(:user) { create(:user) }
  let(:home_id) { create(:home, user: user).id }
  let(:id) { create(:scenario, home_id: home_id).id }

  scenario_response_schema = {
    type: :object,
    properties: {
      id: { type: :integer },
      name: { type: :string },
      scenario_things: {
        type: :array,
        items: { "$ref": "#/definitions/ScenarioThing" },
      },
    },
  }

  scenario_array_schema = {
    type: :array,
    items: scenario_response_schema.deep_dup,
  }

  scenario_params_schema = {
    properties: {
      scenario: scenario_response_schema.deep_dup,
    },
  }
  scenario_params_schema[:properties][:scenario][:properties].delete(:id)

  path "/homes/{home_id}/scenarios", tags: ["Scenarios"] do
    parameter "Authorization", required: true, in: :header, type: :string, description: "auth token"
    parameter "home_id", in: :path, type: :string

    get(summary: "list scenarios") do
      response(200, description: "successful", schema: scenario_array_schema) do
        let(:Authorization) { "Bearer #{token_for(user)}" }
      end

      response(401, description: "not authenticated")
    end

    post(summary: "create scenario") do
      consumes "application/json"
      parameter "body", in: :body, required: true, schema: scenario_params_schema, description: "scenario to create"

      response(201, description: "successful", schema: scenario_response_schema) do
        let(:Authorization) { "Bearer #{token_for(user)}" }
        let(:body) { { scenario: attributes_for(:scenario) } }
      end

      response(400, description: "bad request") do
        let(:Authorization) { "Bearer #{token_for(user)}" }
      end

      response(401, description: "not authenticated")
    end
  end

  path "/scenarios/{id}", tags: ["Scenarios"] do
    parameter "Authorization", required: true, in: :header, type: :string, description: "auth token"
    parameter "id", in: :path, type: :string

    get(summary: "show scenario") do
      response(200, description: "successful", schema: scenario_response_schema) do
        let(:Authorization) { "Bearer #{token_for(user)}" }
      end

      response(401, description: "not authenticated")
    end

    patch(summary: "update scenario") do
      consumes "application/json"
      parameter "body", in: :body, required: true, schema: scenario_params_schema, description: "new scenario data"

      response(200, description: "successful", schema: scenario_response_schema) do
        let(:Authorization) { "Bearer #{token_for(user)}" }
        let(:body) { { scenario: attributes_for(:scenario) } }
      end

      response(400, description: "bad request") do
        let(:Authorization) { "Bearer #{token_for(user)}" }
      end

      response(401, description: "not authenticated")
    end

    put(summary: "update scenario") do
      consumes "application/json"
      parameter "body", in: :body, required: true, schema: scenario_params_schema, description: "new scenario data"

      response(200, description: "successful", schema: scenario_response_schema) do
        let(:Authorization) { "Bearer #{token_for(user)}" }
        let(:body) { { scenario: attributes_for(:scenario) } }
      end

      response(400, description: "bad request") do
        let(:Authorization) { "Bearer #{token_for(user)}" }
      end

      response(401, description: "not authenticated")
    end

    delete(summary: "delete thing") do
      response(204, description: "successful") do
        let(:Authorization) { "Bearer #{token_for(user)}" }
      end

      response(401, description: "not authenticated")
    end
  end
end
