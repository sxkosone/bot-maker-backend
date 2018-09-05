require 'fuzzystringmatch'

class User < ApplicationRecord
    has_many :triggers
    has_many :responses, through: :triggers
    accepts_nested_attributes_for :triggers
    #triggers accept nested attr for :responses
    has_secure_password
    validates :username, presence: true, uniqueness: true

    #these default scripts could be in a separate file
    @@GREETINGS = ["hi", "hey", "hello", "sup", "yo"]
    @@GOODBYES = ["bye", "byebye", "goodbye", "seeya"]
    @@EXISTENTIAL_Q = ["whatareyou", "whoareyou", "areyou", "howdoyouwork", "whatdoyoudo"]
    @@EXISTENTIAL_A = ["I am a friendly bot", "I am a chatbot"]

    #class has a native jaro winkler distance calculator instance for fuzzy string match
    #native is faster (than pure) but cannot handle special chars
    @@fuzzy_match = FuzzyStringMatch::JaroWinkler.create(:native)

    def respond_to_message(user_message, check_defaults)
        msg = User.clean_word(user_message)
        answer = nil
        #first check if any user triggers match message
        self.triggers.map do |trigger|
            #implement fuzzy string matching
            clean_trigger = User.clean_word(trigger.text)
            if User.fuzzy_string_match(msg, clean_trigger)
                random_index = rand(0..trigger.responses.length - 1)
                answer = trigger.responses[random_index].text
            end
        end
        if answer.nil? && check_defaults
            #detect if the message was any of default messages
            answer = self.detect_any_default_messages(msg)
        end
        
        if answer.nil?
            #fallback 
            answer = "I'm sorry, I didn't understand that"
        end
        return {text: answer}
    end

    def detect_any_default_messages(msg)
        #implement fancier fuzzy string match!
        if @@GREETINGS.include?(msg)
            random_i = rand(0..@@GREETINGS.length - 1)
            return @@GREETINGS[random_i]
        elsif @@GOODBYES.include?(msg)
            random_i = rand(0..@@GOODBYES.length - 1)
            return @@GOODBYES[random_i]
        elsif @@EXISTENTIAL_Q.include?(msg)
            random_i = rand(0..@@EXISTENTIAL_A.length - 1)
            return @@EXISTENTIAL_A[random_i]
        else
            return nil
        end
    end

    def detect_message_repetition(msg, history)
        #take in latest sent message and array of all messages
        #see if user has been saying the same thing before, if yes, how many times?
    end

    def self.fuzzy_string_match(msg, compare_msg)
        #uses the Jaro-Winkler distance to represent "distance" between two words
        #strings that have over 0.8 score would be considered a "fuzzy match"
        if @@fuzzy_match.getDistance(msg, compare_msg) >= 0.8
            return true
        else
            return false
        end
    end

    def self.clean_word(string)
        return string.downcase.gsub(/[^0-9a-z]/i, '')
    end

end
