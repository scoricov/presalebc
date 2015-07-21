class ApplicationController < ActionController::API
  rescue_from ActionController::RoutingError, with: :not_found
  rescue_from ActionController::UnknownController, with: :not_found

  def not_found
    render status: 404, plain: 'Not Found.'
  end
end
