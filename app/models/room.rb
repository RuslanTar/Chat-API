class Room < ApplicationRecord
  has_many :room_messages, dependent: :destroy,
           inverse_of: :room
  has_many :users, through: :room_messages
  has_many :assigned_users
  has_many :permited_users, through: :assigned_users#, source: :user

  def message_with_usernames
    room_messages.map { |message|
      message.slice(:id, :username, :avatar, :message, :created_at)
    }
  end

  def message_attributes=(message_attributes)
    message_attributes.values.each do |message|
      message = RoomMessage.find_or_create_by(message)
      self.room_messages << message
    end
  end

  def user_attributes=(user_attributes)
    user_attributes.values.each do |user|
      user = User.find_or_create_by(user)
      self.users << user
    end
  end

  def room_users
    users = []
    self.messages.each do |msg|
      u = User.find_by(username: msg.username)
      unless users.any? { |usr| usr.id == u.id }
        users << u
      end
    end
    users
  end
end
