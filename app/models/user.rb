class User < ApplicationRecord
    #has_secure_password
    #accepts_nested_attributes ...for triggers and responses
    has_many :triggers
    has_many :responses, through: :triggers
end
