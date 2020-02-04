class RoomMessage < ApplicationRecord
  belongs_to :user
  belongs_to :room, inverse_of: :room_messages

  def username
    user.name
  end

  def avatar
    user.avatar
  end
end
