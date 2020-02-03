class User < ApplicationRecord
  has_many :room_messages
  has_many :rooms, through: :room_messages

  has_secure_password
  #mount_uploader :avatar, AvatarUploader
  validates :name, presence: true, uniqueness: true
  validates :email, presence: true, uniqueness: true
  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }
  # validates :avatar
  validates :password,
            length: { minimum: 6 },
            if: -> { new_record? || !password.nil? }
end
