class RoomSerializer < ActiveModel::Serializer
  # has_many :room_messages
  attributes :id, :name
end
