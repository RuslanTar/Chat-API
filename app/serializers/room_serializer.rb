class RoomSerializer < ActiveModel::Serializer
  attributes :id, :name
  has_many :room_messages
end
