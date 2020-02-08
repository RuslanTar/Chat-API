class User < ApplicationRecord
  has_many :room_messages, dependent: :destroy
  has_many :rooms, through: :room_messages
  has_many :assigned_users
  has_many :permited_rooms, through: :assigned_users

  has_secure_password
  validates :name, presence: true, uniqueness: true
  validates :email, presence: true, uniqueness: true
  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :password,
            length: { minimum: 6 },
            if: -> { new_record? || !password.nil? }
end
