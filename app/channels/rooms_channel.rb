class RoomsChannel < ApplicationCable::Channel
  def subscribed
    room = Room.find(params[:conversation])
    stream_for room
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end
end
