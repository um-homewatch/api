require "rails_helper"

describe "homes", type: :request do
  let(:Authorization) { "Bearer nil" }
  let(:user) { create(:user) }
  let(:id) { create(:home, user: user).id }

  home_response_schema = {
    type: :object,
    properties: {
      id: { type: :integer },
      name: { type: :string },
      tunnel: { type: :string, format: :uri },
      location: { type: :string },
      ip_address: { type: :string, format: :ip_address },
    },
  }

  home_array_schema = {
    type: :array,
    items: home_response_schema,
  }

  home_params_schema = {
    properties: {
      home: home_response_schema.deep_dup,
    },
  }
  home_params_schema[:properties][:home][:properties].delete(:id)
  home_params_schema[:properties][:home][:properties].delete(:ip_address)

  path "/homes", tags: ["Homes"] do
    parameter "Authorization", required: true, in: :header, type: :string, description: "auth token"

    get(summary: "list homes") do
      response(200, description: "successful", schema: home_array_schema) do
        let(:Authorization) { "Bearer #{token_for(user)}" }
      end

      response(401, description: "not authenticated")
    end

    post(summary: "create home") do
      consumes "application/json"
      parameter "body", in: :body, required: true, schema: home_params_schema, description: "home to create"

      response(201, description: "successful", schema: home_response_schema) do
        let(:Authorization) { "Bearer #{token_for(user)}" }
        let(:body) { { home: attributes_for(:home) } }
      end

      response(400, description: "bad request") do
        let(:Authorization) { "Bearer #{token_for(user)}" }
      end

      response(401, description: "not authenticated")
    end
  end

  path "/homes/{id}", tags: ["Homes"] do
    parameter "Authorization", required: true, in: :header, type: :string, description: "auth token"
    parameter "id", in: :path, type: :integer

    get(summary: "show home") do
      response(200, description: "successful", schema: home_response_schema) do
        let(:Authorization) { "Bearer #{token_for(user)}" }
      end

      response(401, description: "not authenticated")
    end

    patch(summary: "update home") do
      consumes "application/json"
      parameter "body", in: :body, required: true, schema: home_params_schema, description: "new home data"

      response(200, description: "successful", schema: home_response_schema) do
        let(:Authorization) { "Bearer #{token_for(user)}" }
        let(:body) { { home: attributes_for(:home) } }
      end

      response(400, description: "bad request") do
        let(:Authorization) { "Bearer #{token_for(user)}" }
      end

      response(401, description: "not authenticated")
    end

    put(summary: "update home") do
      consumes "application/json"
      parameter "body", in: :body, required: true, schema: home_params_schema, description: "new home data"

      response(200, description: "successful", schema: home_response_schema) do
        let(:Authorization) { "Bearer #{token_for(user)}" }
        let(:body) { { home: attributes_for(:home) } }
      end

      response(400, description: "bad request") do
        let(:Authorization) { "Bearer #{token_for(user)}" }
      end

      response(401, description: "not authenticated")
    end

    delete(summary: "delete home") do
      response(204, description: "successful") do
        let(:Authorization) { "Bearer #{token_for(user)}" }
      end

      response(401, description: "not authenticated")
    end
  end
end
