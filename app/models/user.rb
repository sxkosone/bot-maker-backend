class User < ApplicationRecord
    has_many :triggers
    has_many :responses, through: :triggers
    accepts_nested_attributes_for :triggers
    #triggers accept nested attr for :responses
    has_secure_password
    validates :username, presence: true, uniqueness: true

    @@GREETINGS = ["hi", "hey", "hello", "sup", "yo"]
    @@GOODBYES = ["bye", "byebye", "goodbye", "seeya"]

    def respond_to_message(user_message)
        msg = user_message.downcase.gsub(/[^0-9a-z]/i, '')
        answer = nil
        #first check if any user triggers match message
        self.triggers.map do |trigger|
            #implement some fancier fuzzy string matching
            if trigger.text.downcase.gsub(/[^0-9a-z]/i, '') == msg
                random_index = rand(0..trigger.responses.length - 1)
                answer = trigger.responses[random_index].text
            end
        end
        if answer.nil?
            #detect if the message was a greeting
            answer = self.detect_greetings_and_goodbyes(msg)
        end
        
        if answer.nil?
            #fallback 
            answer = "I didn't understand that"
        end
        return {text: answer}
    end

    def detect_greetings_and_goodbyes(msg)
        if @@GREETINGS.include?(msg)
            random_i = rand(0..@@GREETINGS.length - 1)
            return @@GREETINGS[random_i]
        elsif @@GOODBYES.include?(msg)
            random_i = rand(0..@@GOODBYES.length - 1)
            return @@GOODBYES[random_i]
        else
            return nil
        end
    end

end
