require "rails_helper"

describe "users", type: :request do
  let(:Authorization) { "Bearer nil" }

  user_schema = {
    properties: {
      user: {
        type: :object,
        properties: {
          id: { type: :integer },
          name: { type: :string },
          email: { type: :string, format: :email },
        },
      },
    },
  }

  user_password_schema = user_schema.deep_dup
  user_password_schema[:properties][:user][:properties].delete(:id)
  user_password_schema[:properties][:user][:properties].merge!(password: { type: :string },
                                                               password_confirmation: { type: :string })

  user_token_schema = user_schema.deep_dup
  user_token_schema[:properties][:user][:properties].delete(:id)
  user_token_schema[:properties][:user][:properties][:jwt] = { type: :string }

  path "/users", tags: ["Users"] do
    post(summary: "create user") do
      consumes "application/json"
      parameter "body", required: true, in: :body, schema: user_password_schema, description: "user to register"

      response(201, description: "successful", schema: user_token_schema) do
        let(:body) { { user: attributes_for(:user) } }
      end

      response(400, description: "bad params")
    end
  end

  path "/users/me", tags: ["Users"] do
    parameter "Authorization", required: true, in: :header, type: :string, description: "auth token"

    get(summary: "show user") do
      response(200, description: "successful", schema: user_schema) do
        let(:Authorization) { "Bearer #{token_for}" }
      end

      response(401, description: "not authenticated")
    end

    patch(summary: "update user") do
      consumes "application/json"
      parameter "body", in: :body, required: true, schema: user_password_schema, description: "new user params"

      response(200, description: "successful", schema: user_token_schema) do
        let(:Authorization) { "Bearer #{token_for}" }
        let(:body) { { user: attributes_for(:user) } }
      end

      response(400, description: "bad request") do
        let(:Authorization) { "Bearer #{token_for}" }
      end

      response(401, description: "not authenticated")
    end

    put(summary: "update user") do
      consumes "application/json"
      parameter "body", in: :body, required: true, schema: user_password_schema, description: "new user params"

      response(200, description: "successful", schema: user_token_schema) do
        let(:Authorization) { "Bearer #{token_for}" }
        let(:body) { { user: attributes_for(:user) } }
      end

      response(400, description: "bad request") do
        let(:Authorization) { "Bearer #{token_for}" }
      end

      response(401, description: "not authenticated")
    end
  end
end
