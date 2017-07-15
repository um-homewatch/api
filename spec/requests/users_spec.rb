require "rails_helper"

RSpec.describe "users", type: :request do
  user_schema = {
    type: :object,
    properties: {
      id: {type: :integer},
      name: { type: :string },
      email: { type: :email },
    },
  }

  user_password_schema = user_schema.clone
  user_password_schema[:properties].delete(id)
  user_password_schema[:properties].merge!(password: { type: :string },
                                           password_confirmation: { type: :string })

  user_token_schema = user_schema.clone
  user_token_schema[:properties].delete(id)
  user_token_schema[:properties].merge!(jwt: { type: :string })

  path "/users" do
    post(summary: "create user") do
      consumes "application/json"
      parameter "body", in: :body, schema: user_password_schema

      response(200, description: "successful", schema: user_token_schema) do
        let(:body) { { user: attributes_for(:user) } }
      end

      response(400, description: "bad params")
    end
  end

  path "/users/me" do
    parameter "Authorization", in: :header, type: :string

    get(summary: "show user") do
      response(200, description: "successful", schema: user_schema) do
        let(:Authorization) { "Bearer #{token_for}" }
      end

      response(401, description: "not authenticated")
    end

    patch(summary: "update user") do
      consumes "application/json"
      parameter "body", in: :body, schema: user_password_schema
      let(:body) { { user: attributes_for(:user) } }

      response(200, description: "successful", schema: user_token_schema) do
        let(:Authorization) { "Bearer #{token_for}" }
      end

      response(401, description: "not authenticated")
    end

    put(summary: "update user") do
      consumes "application/json"
      parameter "body", in: :body, schema: user_password_schema
      let(:body) { { user: attributes_for(:user) } }

      response(200, description: "successful", schema: user_token_schema) do
        let(:Authorization) { "Bearer #{token_for}" }
      end

      response(401, description: "not authenticated")
    end
  end
end
