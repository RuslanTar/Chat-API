class RoomMessagesController < ApplicationController
  before_action :load_entities
  before_action :find_user, except: %i[create index]

  def create
    @room_message = RoomMessage.create user: @user,
                                       room: @room,
                                       message: params.dig(:room_message, :message)
  end

  protected

  def load_entities
    @room = Room.find params.dig(:room_message, :room_id)
  end
end