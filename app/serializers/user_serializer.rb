class UserSerializer < ActiveModel::Serializer
  has_many :bots
  attributes :id, :username
end
