class User < ApplicationRecord
    has_many :triggers
    has_many :responses, through: :triggers

    accepts_nested_attributes_for :triggers
    #triggers accept nested attr for :responses

    has_secure_password

    validates :username, presence: true, uniqueness: true
end
