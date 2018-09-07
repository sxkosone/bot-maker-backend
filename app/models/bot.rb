require 'fuzzystringmatch'
require 'classifier-reborn'

class Bot < ApplicationRecord
    belongs_to :user
    #this used to be in user
    has_many :triggers
    has_many :responses, through: :triggers
    accepts_nested_attributes_for :triggers

    #these default scripts could be in a separate file

    @@GREETINGS = ["hi", "hey", "hello", "sup", "yo"]
    @@GOODBYES = ["bye", "byebye", "goodbye", "seeya"]
    @@EASY_QUESTIONS = ["howareyou", "howsitgoing", "howareyoutoday", "whatsup", "wussup"]
    @@EXISTENTIAL_Q = ["whatareyou", "areyou", "doyouwork", "whatdoyoudo", "youreal"]

    @@EXISTENTIAL_A = ["I am a friendly bot", "I am a chatbot", "I'm a chatbot, the kind humans can program on this website"]
    @@APOLOGIES_UNDERSTANDING = ["I can see I'm not understanding you very well", "There seems to be some misunderstanding here", "I know this is getting old, but I'm still not understanding", "I still don't understand you", "That's not something I know how to answer to"]
    @@EASY_ANSWERS = ["I'm okay, thanks for asking!", "Well, I don't have feelings because I am a bot", "It's going okay, how about you?"]
    
    #class has a native jaro winkler distance calculator instance for fuzzy string match
    #native is faster (than pure) but cannot handle special chars
    #should I save and retrieve this from the database or nah?
    @@fuzzy_match = FuzzyStringMatch::JaroWinkler.create(:native)

    def respond_to_message(user_message, history, check_defaults=true)
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

        if User.bad_understanding(history)
            
            random_index = rand(0..@@APOLOGIES_UNDERSTANDING.length - 1)
            answer = @@APOLOGIES_UNDERSTANDING[random_index]
        end

        return {text: answer}
    end

    def detect_any_default_messages(msg)
        #implement fancier fuzzy string match!
        if User.fuzzy_string_match_array(msg, @@GREETINGS)
            random_i = rand(0..@@GREETINGS.length - 1)
            return @@GREETINGS[random_i]
        elsif User.fuzzy_string_match_array(msg, @@GOODBYES)
            random_i = rand(0..@@GOODBYES.length - 1)
            return @@GOODBYES[random_i]
        elsif User.fuzzy_string_match_array(msg, @@EXISTENTIAL_Q)
            random_i = rand(0..@@EXISTENTIAL_A.length - 1)
            return @@EXISTENTIAL_A[random_i]
        elsif User.fuzzy_string_match_array(msg, @@EASY_QUESTIONS)
            random_i = rand(0..@@EASY_ANSWERS.length - 1)
            return @@EASY_ANSWERS[random_i]
        else
            return nil
        end
    end

    def detect_message_repetition(msg, history)
        #take in latest sent message and array of all messages
        #example: "message_history"=>[{"sender"=>"human", "text"=>"hi"}, {"sender"=>"bot", "text"=>"o hai"}]
        #see if user has been saying the same thing before, if yes, how many times?

    end

    def self.bad_understanding(history)
        if history.length > 4
            #see if bot has said I dont understand in the last message
            if history[-2]["text"] == "I'm sorry, I didn't understand that"
                return true
            else
                return false
            end
        end
        return false
    end

    def self.fuzzy_string_match(msg, compare_msg)
        #uses the Jaro-Winkler distance algorithm to represent "distance" between two words
        #strings that have over 0.8 score would be considered a "fuzzy match"
        if @@fuzzy_match.getDistance(msg, compare_msg) >= 0.8
            return true
        else
            return false
        end
    end

    def self.fuzzy_string_match_array(msg, array)
        #take an array of possible matches and look if message fuzzy matches any of them
        array.each do |string|
            if User.fuzzy_string_match(msg, string)
                return true
            end
        end
        return false
    end

    def self.clean_word(string)
        return string.downcase.gsub(/[^0-9a-z]/i, '')
    end

end