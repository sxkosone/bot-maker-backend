class BotSerializer < ActiveModel::Serializer
  belongs_to :user
  has_many :triggers
  has_many :responses, through: :triggers
  attributes :id, :user_id, :name, :url_id, :include_default_scripts, :include_classifier, :description
end
