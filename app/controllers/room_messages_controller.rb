class RoomMessagesController < ApplicationController
  before_action :load_entities
  before_action :find_user, except: %i[create index]

  def create
    room_message = Message.new(message_params)
    room = Room.find(message_params[:room_id])
    if room_message.save
      serialized_data = ActiveModelSerializers::Adapter::Json.new(
          RoomMessageSerializer.new(room_message)
      ).serializable_hash
      RoomMessagesChannel.broadcast_to room, serialized_data
      head :ok
    end
  end

  private

  def message_params
    params.require(:room_message).permit(:message, :room_id)
  end
  
  def load_entities
    @room = Room.find params.dig(:room_message, :room_id)
  end
end

