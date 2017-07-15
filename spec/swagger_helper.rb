require "rspec/rails/swagger"
require "rails_helper"

RSpec.configure do |config|
  # Specify a root directory where the generated Swagger files will be saved.
  config.swagger_root = Rails.root.to_s + "/swagger"

  # Define one or more Swagger documents and global metadata for each.
  config.swagger_docs = {
    "v1/swagger.json" => {
      swagger: "2.0",
      info: {
        title: "Homewatch API",
        version: "v1",
        description: "Homewatch API Swagger Documentation",
      },
      host: "homewatch-api.herokuapp.com",
    },
  }
end
