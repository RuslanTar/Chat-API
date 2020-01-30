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
    @user.avatar = "https://gravatar.com/avatar/#{gravatar_id}.png?s=#{size}&d=#{"https://api.adorable.io/avatars/#{size}/#{@user.name}.png"}"
    if @user.save
      token = JsonWebToken.encode(user_id: @user.id)
      time = Time.now + 24.hours.to_i
      render json: { resultCode: 0, token: token, exp: time.strftime("%m-%d-%Y %H:%M"), message: "You are currently Logged-in as #{@user.name}"}, status: :ok
    else
      render json: { resultCode: 1, errors: @user.errors.full_messages },
             status: :ok #:unprocessable_entity
    end
  end

  # def gravatar_url(email)
  #   gravatar_id = Digest::MD5::hexdigest(email).downcase
  #   return url = "https://gravatar.com/avatar/#{gravatar_id}.png"
  # end

  # PATCH /profile/update
  def update
    if @user&.authenticate(params[:password])
      @user.name = params[:name]
      @user.email = params[:email]
      gravatar_id = Digest::MD5::hexdigest(@user.email.downcase)
      size = 285
      @user.avatar = "https://gravatar.com/avatar/#{gravatar_id}.png?s=#{size}&d=#{"https://api.adorable.io/avatars/#{size}/#{@user.name}.png"}"
      unless params[:newPassword].nil?
        @user.password = params[:newPassword]
      end
      if @user.save
        render json: { resultCode: 0, message: "Profile successfully updated" }, status: :ok
      else
        render json: { resultCode: 1, errors: @user.errors.full_messages}, status: :ok
      end
    else
      render json: { resultCode: 1, errors: ["Invalid current password"] }
    end
  end

  # # PATCH /profile/password
  # def password_update
  #   if @user&.authenticate(params[:password])
  #     @user.password = :newPassword
  #     if @user.save
  #       render json: { resultCode: 0, message: "Password successfully changed" }, status: :ok
  #     else
  #       render json: { resultCode: 1, errors: @user.errors.full_messages}, status: :ok
  #     end
  #   else
  #     render json: { resultCode: 1, errors: ["Invalid old password"]}, status: :ok
  #   end
  # end

  # DELETE /users/delete
  def destroy
    if @user.destroy
      render json: { resultCode: 0, message: 'User has been deleted.' }, status: :ok
    else
      render json: { resultCode: 1, errors: @user.errors.full_messages }, status: :ok
    end
    # end
  end

  # Call this method to check if the user is logged-in.
  # If the user is logged-in we will return the user's information.
  # GET /auth/me
  def current
    if @user.update!(last_login: Time.now)
      render json: { resultCode: 0, user: {id: @user.id, name: @user.name, avatar: @user.avatar } }, status: :ok
    else
      render json: { resultCode: 1, errors: @user.errors.full_messages }, status: :ok
    end

  end

  # GET /profile
  def current_profile
    render json: { resultCode: 0, user: {id: @user.id, name: @user.name, email: @user.email, avatar: @user.avatar } }, status: :ok
  end

  # GET /profile/:id
  def profile
    @user_needed = User.find_by_id(params[:id])
    render json: { resultCode: 0, user: {id: @user_needed.id, name: @user_needed.name, avatar: @user_needed.avatar } }, status: :ok
  end

  private

  def find_user
    header = request.headers['Authorization']
    header = header.split(' ').last if header

    @decoded = JsonWebToken.decode(header)
    @user = User.find(@decoded[:user_id])
    #@user = User.find_by_name!(params[:_name])
  rescue ActiveRecord::RecordNotFound
    render json: { resultCode: 1, errors: ['User not found'] }, status: :ok # :not_found
  end

  def user_params
    params.permit(
        :name, :email, :password, :avatar
    )
  end
end