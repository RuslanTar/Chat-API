class RoomsController < ApplicationController
  # before_action :load_entities
  before_action :current_user
  before_action :set_room, except: [:create, :index]

  def index
    @rooms = Room.all
    render json: @rooms.select {|room| room.permited_users.include?(@user) }
  end

  def create
    @room = Room.new(permited_parameters)

    if @room.save
      serialized_data = ActiveModelSerializers::Adapter::Json.new(
          RoomSerializer.new(@room)
      ).serializable_hash
      @room.assigned_users.create(user: @user)
      ActionCable.server.broadcast 'rooms', serialized_data
      render json: serialized_data
    else
      render json: { errors: @room.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def show
    if @room.permited_users.include?(@user)
      @room_messages = @room.room_messages
      render json: { message: @room_messages }, status: :ok
    else
      render json: { message: "User forbidden" }, status: :forbidden
    end
  end

  def assign_user
    @room.assigned_users.create(user: User.find_by_name(params[:name]))
    render json: @room.permited_users
  end

  def remove_assign_user
    usr = User.find_by_name(params[:name])
    if @room.assigned_users.find_by(user: usr)
      @room.assigned_users.find_by(user: usr).destroy
      head :ok
    else
      render json: { errors: "This user don't assigned in this chat" }, status: :forbidden
    end
  end

  def send_message
    @message = @room.room_messages.create(message: params[:message], user: @user)
    ActionCable.server.broadcast('messages', @room)
    render json: @room.message_with_usernames
  end

  private

  def current_user
    header = request.headers['Authorization']
    header = header.split(' ').last if header
    decoded = JsonWebToken.decode(header)
    @user = User.find(decoded[:user_id])
  rescue ActiveRecord::RecordNotFound
    render json: { errors: ['User not found'] }, status: :not_found
  end

  def set_room
    @room = Room.find(params[:id])
  end

  # def load_entities
  #   @rooms = Room.all
  #   @room = Room.find(params[:id]) if params[:id]
  # end

  def permited_parameters
    params.require(:room).permit(:name)
  end
end