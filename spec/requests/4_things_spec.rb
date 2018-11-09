require "rails_helper"

describe "things", type: :request do
  let(:Authorization) { "Bearer nil" }
  let(:user) { create(:user) }
  let(:home_id) { create(:home, user: user).id }
  let(:id) { create(:light, home_id: home_id).id }

  thing_response_schema = {
    type: :object,
    properties: {
      id: { type: :integer },
      name: { type: :string },
      type: { type: :string, enum: Thing.types },
      subtype: { type: :string },
      connection_info: { type: :object },
    },
  }

  thing_array_schema = {
    type: :array,
    items: thing_response_schema,
  }

  thing_params_schema = {
    properties: {
      thing: thing_response_schema.deep_dup,
    },
  }
  thing_params_schema[:properties][:thing][:properties].delete(:id)

  path "/homes/{home_id}/things", tags: ["Things"] do
    parameter "Authorization", required: true, in: :header, type: :string, description: "auth token"
    parameter "home_id", in: :path, type: :integer

    get(summary: "list things") do
      response(200, description: "successful", schema: thing_array_schema) do
        let(:Authorization) { "Bearer #{token_for(user)}" }
      end

      response(401, description: "not authenticated")
    end

    post(summary: "create thing") do
      consumes "application/json"
      parameter "body", in: :body, required: true, schema: thing_params_schema, description: "thing to create"

      response(201, description: "successful", schema: thing_response_schema) do
        let(:Authorization) { "Bearer #{token_for(user)}" }
        let(:body) { { thing: attributes_for(:light) } }
      end

      response(400, description: "bad request") do
        let(:Authorization) { "Bearer #{token_for(user)}" }
      end

      response(401, description: "not authenticated")
    end
  end

  path "/things/{id}", tags: ["Things"] do
    parameter "Authorization", required: true, in: :header, type: :string, description: "auth token"
    parameter "id", in: :path, type: :number

    get(summary: "show thing") do
      response(200, description: "successful", schema: thing_response_schema) do
        let(:Authorization) { "Bearer #{token_for(user)}" }
      end

      response(401, description: "not authenticated")
    end

    patch(summary: "update thing") do
      consumes "application/json"
      parameter "body", in: :body, required: true, schema: thing_params_schema, description: "new thing data"

      response(200, description: "successful", schema: thing_response_schema) do
        let(:Authorization) { "Bearer #{token_for(user)}" }
        let(:body) { { thing: attributes_for(:light) } }
      end

      response(400, description: "bad request") do
        let(:Authorization) { "Bearer #{token_for(user)}" }
      end

      response(401, description: "not authenticated")
    end

    put(summary: "update thing") do
      consumes "application/json"
      parameter "body", in: :body, required: true, schema: thing_params_schema, description: "new thing data"

      response(200, description: "successful", schema: thing_response_schema) do
        let(:Authorization) { "Bearer #{token_for(user)}" }
        let(:body) { { thing: attributes_for(:light) } }
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
