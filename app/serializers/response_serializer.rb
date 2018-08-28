class ResponseSerializer < ActiveModel::Serializer
  belongs_to :trigger
  attributes :id, :text, :trigger_id
end
