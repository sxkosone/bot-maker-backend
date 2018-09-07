class TriggerSerializer < ActiveModel::Serializer
  has_many :responses
  belongs_to :bot
  attributes :id, :text, :bot_id
end
