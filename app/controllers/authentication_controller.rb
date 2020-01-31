class AuthenticationController < ApplicationController
  before_action :authorize_request, except: :login

  # Authorized only method
  def auth
    render json: { status: 200, msg: "You are currently Logged-in as #{@user.name}" }
  end

  # POST /auth/login
  def login
    @user = User.find_by_email(params[:email])
    if @user&.authenticate(params[:password])
      token = JsonWebToken.encode(user_id: @user.id)
      if params[:rememberMe]==true
        time = Time.now + 168.hours.to_i
      else
        time = Time.now + 24.hours.to_i
      end
      render json: { resultCode: 0, REMEMBERME: params[:rememberMe], isTRUE: params[:rememberMe]==true,token: token, exp: time.strftime("%m-%d-%Y %H:%M"), message: "You are currently Logged-in as #{@user.name}"}, status: :ok
    else
      render json: { resultCode: 1, errors: ['Incorrect login or password'] }, status: :unauthorized
    end
  end

  private

  def login_params
    params.permit(:email, :password, :rememberMe)
  end
end