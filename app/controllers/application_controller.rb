class ApplicationController < ActionController::Base
  before_action :basic_auth, if: :production?
  # before_action :authenticate_user!
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :set_host

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name])
  end

  def set_host
    Rails.application.routes.default_url_options[:host] = request.host_with_port
  end

  private

  def basic_auth
    authenticate_or_request_with_http_basic do |username, password|
      username == Rails.application.credentials[:basic_auth][:user] &&
      password == Rails.application.credentials[:basic_auth][:pass]
    end
  end

  def production?
    Rails.env.production?
  end

end
