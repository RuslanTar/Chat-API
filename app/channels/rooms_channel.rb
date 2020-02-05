class RoomsChannel < ApplicationCable::Channel
  def subscribed
    @room = Room.find(params[:room])
    stream_for 'rooms'
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end
end
