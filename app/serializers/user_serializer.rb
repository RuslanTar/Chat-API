class UserSerializer < ActiveModel::Serializer
  attributes :id, :name, :email, :avatar, :last_login, :created_at, :updated_at
end