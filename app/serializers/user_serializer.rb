class UserSerializer < ActiveModel::Serializer
  has_many :triggers
  has_many :responses, through: :triggers
  attributes :id, :username, :bot_name, :bot_url_id
end
