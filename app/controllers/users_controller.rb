class UsersController < ApplicationController
  before_action :authorize_request, except: :create
  before_action :find_user, except: %i[create index]

  # GET /users
  def index
    @users = User.all
    render json: @users, status: :ok
  end

  # GET /users/{name}
  def show
    render json: @user, status: :ok
  end

  # POST /users
  def create
    @user = User.new(user_params)
    if @user.save
      render json: { resultCode: 0, user: @user }, status: :created
    else
      render json: { resultCode: 1, errors: @user.errors.full_messages },
             status: :ok #:unprocessable_entity
    end
  end

  # PUT /users/{name}
  def update
    if @user.update(user_params)
      render json: { resultCode: 0, message: "Updates succesful"},
             status: :ok
    else
      render json: { resultCode: 1, user: @user, errors: @user.errors.full_messages},
             status: :ok #:unprocessable_entity
    end
  end

  # DELETE /users/{name}
  def destroy
    if @user.destroy
      render json: { resultCode: 0, status: 200, message: 'User has been deleted.' }
    else
      render json: { resultCode: 1, status: 200, errors: @user.errors.full_messages }
    end
    # end
  end

  # Call this method to check if the user is logged-in.
  # If the user is logged-in we will return the user's information.
  def current
    if @user.update!(last_login: Time.now)
      render json: { resultCode: 0, status: :ok, user: {id: @user.id, name: @user.name, email: @user.email} }
    else
      render json: { resultCode: 1, status: :ok, errors: @user.errors.full_messages }
    end

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
        :name, :email, :password #:avatar,
    )
  end
end