class UsersController < ApplicationController
  before_action :authorize_request, except: :create
  before_action :find_user, except: %i[create index]

  # GET /users
  def index
    @users = User.all
    render json: @users, status: :ok
  end

  # GET /users/show
  def show
    render json: @user, status: :ok
  end

  # POST /users/create
  def create
    @user = User.new(user_params)
    gravatar_id = Digest::MD5::hexdigest(@user.email.downcase)
    size= 285
    @user.avatar = "https://gravatar.com/avatar/#{gravatar_id}.png?s=#{size}&d=#{"https://api.adorable.io/avatars/#{size}/#{@user.name.delete(' ')}.png"}"
    if @user.save
      token = JsonWebToken.encode(user_id: @user.id)
      time = Time.now + 24.hours.to_i
      render json: { token: token, exp: time.strftime("%m-%d-%Y %H:%M"), message: "You are currently Logged-in as #{@user.name}"}, status: :created
    else
      render json: { errors: @user.errors.full_messages }, status: :unprocessable_entity
    end
  end

  # PATCH /profile/update
  def update
    if @user&.authenticate(params[:password])
      @user.name = params[:name]
      @user.email = params[:email]
      gravatar_id = Digest::MD5::hexdigest(@user.email.downcase)
      size = 285
      @user.avatar = "https://gravatar.com/avatar/#{gravatar_id}.png?s=#{size}&d=#{"https://api.adorable.io/avatars/#{size}/#{@user.name.delete(' ')}.png"}"
      unless params[:newPassword].nil?
        @user.password = params[:newPassword]
      end
      if @user.save
        render json: { message: "Profile successfully updated" }, status: :ok
      else
        render json: { errors: @user.errors.full_messages}, status: :unprocessable_entity
      end
    else
      render json: { errors: ["Invalid current password"] }, status: :unauthorized
    end
  end

  # DELETE /users/delete
  def destroy
    if @user.destroy
      render json: { message: 'User has been deleted.' }, status: :ok
    else
      render json: {errors: @user.errors.full_messages }, status: :unprocessable_entity
    end
    # end
  end

  # Call this method to check if the user is logged-in.
  # If the user is logged-in we will return the user's information.
  # GET /auth/me
  def current
    if @user.update!(last_login: Time.now)
      render json: { user: {id: @user.id, name: @user.name, avatar: @user.avatar } }, status: :ok
    else
      render json: { errors: @user.errors.full_messages }, status: :unprocessable_entity
    end

  end

  # GET /profile
  def current_profile
    render json: { user: {id: @user.id, name: @user.name, email: @user.email, avatar: @user.avatar } }, status: :ok
  end

  # GET /profile/:id
  def profile
    @user_needed = User.find_by_id(params[:id])
    render json: { user: {id: @user_needed.id, name: @user_needed.name, avatar: @user_needed.avatar } }, status: :ok
  end

  def refresh
    token = JsonWebToken.encode(user_id: @user.id)
    time = Time.now + 24.hours.to_i
    render json: { resultCode: 0, token: token, exp: time.strftime("%m-%d-%Y %H:%M"), message: "You are currently Logged-in as #{@user.name}"}, status: :ok
  end

  private

  def find_user
    header = request.headers['Authorization']
    header = header.split(' ').last if header

    @decoded = JsonWebToken.decode(header)
    @user = User.find(@decoded[:user_id])
    #@user = User.find_by_name!(params[:_name])
  rescue ActiveRecord::RecordNotFound
    render json: { errors: ['User not found'] }, status: :not_found
  end

  def user_params
    params.permit(
        :name, :email, :password, :avatar
    )
  end
end