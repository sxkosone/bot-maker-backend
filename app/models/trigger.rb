class Trigger < ApplicationRecord
    belongs_to :user
    has_many :responses
    accepts_nested_attributes_for :responses
end
