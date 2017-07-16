require "swagger_helper"

RSpec.describe "user_token", type: :request do
  let(:user) { create(:user) }
  let(:auth) { { email: user.email, password: user.password } }
  let(:bad_auth) { { email: user.email, password: (user.password + "1") } }

  auth_schema = {
    properties: {
      auth: {
        type: :object,
        properties: {
          email: { type: :string, format: :email },
          password: { type: :string },
        },
      },
    },
  }

  user_schema = {
    properties: {
      id: { type: :integer },
      name: { type: :string },
      email: { type: :string, format: :email },
      jwt: { type: :string },
    },
  }

  path "/auth", tags: ["Auth"] do
    post(summary: "create user_token") do
      consumes "application/json"
      parameter "body", required: true, in: :body, schema: auth_schema, description: "user to register"

      response(201, description: "successful", schema: user_schema) do
        let(:body) { { auth: auth } }
      end

      response(404, description: "bad credentials") do
        let(:body) { { auth: bad_auth } }
      end

      response(400, description: "bad params")
    end

    get(summary: "show user_token") do
      parameter "Authorization", required: true, in: :header, type: :string, description: "auth token"

      response(200, description: "successful", schema: user_schema) do
        let(:Authorization) { "Bearer #{token_for}" }
      end
    end
  end
end
