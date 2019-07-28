class ApplicationController < ActionController::Base
  helper_method :current_user
  before_action :authenticate_user!

  protect_from_forgery with: :exception

  rescue_from ActiveRecord::RecordNotFound, with: :render_404
  rescue_from ActionController::RoutingError, with: :render_404
  rescue_from Exception, with: :render_500

  def render_404(exception = nil)
    if exception
      logger.info "Rendering 404 with exception: #{exception.message}"
    end
    render template: "errors/error_404", status: 404, layout: 'application'
  end

  def render_500(exception = nil)
    if exception
      logger.info "Rendering 500 with exception: #{exception.message}"
    end
    render template: "errors/error_500", status: 500, layout: 'application'
  end 

  private
  
  def current_user
    @current_user ||= User.find_by(id: session[:user_id])
  end
  
  def authenticate_user!
    redirect_to login_path unless current_user
  end
end
  