class ApplicationController < ActionController::API

  # after_filter :set_access_control_headers
  before_action :set_access_control_headers

  def not_found
    render json: { error: 'not_found' }
  end

  # def handle_options_request
  #   head(:ok) if request.request_method == "OPTIONS"
  # end
  #
  # def set_access_control_headers
  #   headers['Access-Control-Allow-Origin'] = '*'
  #   headers['Access-Control-Allow-Methods'] = 'GET, POST, PUT, DELETE'
  # end
  #



  def cors_preflight_check
    if request.method == 'OPTIONS'
      set_access_control_headers
      render text: '', content_type: 'text/plain'
    end
  end

  protected

  def set_access_control_headers
    response.headers['Access-Control-Allow-Origin'] = '*'
    response.headers['Access-Control-Allow-Methods'] = 'POST, GET, PUT, PATCH, DELETE, OPTIONS'
    response.headers['Access-Control-Allow-Headers'] = 'Origin, Content-Type, Accept, Authorization, Token, Auth-Token, Email, X-User-Token, X-User-Email'
    response.headers['Access-Control-Max-Age'] = '1728000'
  end

  def authorize_request
    header = request.headers['Authorization']
    header = header.split(' ').last if header
    begin
      @decoded = JsonWebToken.decode(header)
      @current_user = User.find(@decoded[:user_id])
    rescue ActiveRecord::RecordNotFound => e
      render json: { errors: e.message }, status: :unauthorized
    rescue JWT::DecodeError => e
      render json: { errors: e.message }, status: :unauthorized
    end
  end
end