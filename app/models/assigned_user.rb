class AssignedUser < ApplicationRecord
  belongs_to :room
  belongs_to :user#, dependent: :destroy

  validates :user, uniqueness: { scope: :room }
end
