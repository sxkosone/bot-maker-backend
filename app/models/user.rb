# require 'fuzzystringmatch'
# require 'classifier-reborn'
#this may have to be changed to a bot class
class User < ApplicationRecord
    #moved to bot
    # has_many :triggers
    # has_many :responses, through: :triggers
    
    #triggers accept nested attr for :responses
    has_many :bots
    accepts_nested_attributes_for :bots
    #accepts_nested_attributes_for :triggers
    has_secure_password
    validates :username, presence: true, uniqueness: true

end
