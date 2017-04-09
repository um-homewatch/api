class ApplicationController < ActionController::API
  include Knock::Authenticable

  rescue_from "ActiveRecord::RecordNotFound" do
    head :not_found
  end
end
