class RoomMessageSerializer < ActiveModel::Serializer
  attributes :id, :room_id, :user_id, :message, :created_at
end
