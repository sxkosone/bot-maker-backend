class TriggerSerializer < ActiveModel::Serializer
  has_many :responses
  belongs_to :user
  attributes :id, :text, :user_id
end
