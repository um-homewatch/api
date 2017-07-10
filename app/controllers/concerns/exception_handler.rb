# When this module is included by a controller it manages all of it's exceptions
# with custom handlers, reporting internal servor errors to an external provider
module ExceptionHandler
  extend ActiveSupport::Concern

  included do
    if Rails.env.production?
      rescue_from StandardError do |error|
        internal_server_error(error)
      end
    end
    rescue_from ActiveRecord::RecordNotFound, with: :not_found
    rescue_from ActionController::ParameterMissing, with: :missing_params
  end

  private

  def subclass_not_found
    render status: :bad_request, json: { "error" => "Unknown type. You must pass a valid subclass to type." }
  end

  def not_found
    render status: :not_found, json: { "error" => "Resource not found." }
  end

  def missing_params
    render status: :bad_request, json: { "error" => "Missing params." }
  end

  def internal_server_error(error)
    Rollbar.error(error)

    render(
      status: :internal_server_error,
      json: {
        "error" => "Internal Server Error. Our engineers have been notified of the occurrence.",
      },
    )
  end
end
