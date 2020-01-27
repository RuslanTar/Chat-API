class UserSerializer < ActiveModel::Serializer
  attributes :id, :name, :email, :last_login, :created_at, :updated_at
end