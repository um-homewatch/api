class ApplicationController < ActionController::API
  include Knock::Authenticable
  include ExceptionHandler
end
