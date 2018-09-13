require 'fuzzystringmatch'
require 'classifier-reborn'

class Bot < ApplicationRecord
    belongs_to :user
    #this used to be in user
    has_many :triggers
    has_many :responses, through: :triggers
    has_many :fallbacks
    has_one :classifier
    has_many :classifier_responses
    accepts_nested_attributes_for :triggers
    accepts_nested_attributes_for :fallbacks

    #these default scripts could be in a separate file

    @@GREETINGS = ["hi", "hey", "hello", "morning"]
    @@GOODBYES = ["bye", "byebye", "goodbye", "seeya"]
    @@EASY_QUESTIONS = ["howareyou", "howsitgoing", "howareyoutoday", "whatsup", "wussup"]
    @@EXISTENTIAL_Q = ["whatareyou", "whatdoyoudo", "areyoureal"]

    @@EXISTENTIAL_A = ["I am a friendly bot", "I am a chatbot", "I'm a chatbot, the kind humans can program on this website"]
    @@APOLOGIES_UNDERSTANDING = ["I can see I'm not understanding. Can you rephrase?", "There seems to be some misunderstanding here...", "I don't understand, can you rephrase?", "I still don't understand you. Can you say that again differently?", "That's not something I know how to answer to"]
    @@EASY_ANSWERS = ["I'm okay, thanks for asking!", "Well, I don't have feelings because I am a bot", "It's going okay, how about you?"]
    
    #class has a native jaro winkler distance calculator instance for fuzzy string match
    #native is faster (than pure) but cannot handle special chars
    #should I save and retrieve this from the database or nah?
    @@fuzzy_match = FuzzyStringMatch::JaroWinkler.create(:native)

    def respond_to_message(user_message, history, check_defaults=true)
        msg = Bot.clean_word(user_message)
        answer = nil

        #first check if any user triggers match message
        self.triggers.map do |trigger|
            #implement fuzzy string matching
            clean_trigger = Bot.clean_word(trigger.text)
            if Bot.fuzzy_string_match(msg, clean_trigger)
                #random_index = rand(0..trigger.responses.length - 1)
                answer = trigger.responses.sample.text
            end
        end

        #second, classify using machine learning instance
        if answer.nil? && self.include_classifier
            answer = self.classify(user_message)
        end

        #third, detect if the message was any of default messages
        if answer.nil? && check_defaults
            answer = self.detect_any_default_messages(msg)
        end

        #fallback
        if answer.nil? 
            answer = "I'm sorry, I didn't understand that"
            if self.fallbacks.any?
                answer = self.fallbacks.sample.text
                
            elsif Bot.bad_understanding(history)
            #check if you've said I don't understand a lot
                #random_index = rand(0..@@APOLOGIES_UNDERSTANDING.length - 1)
                answer = @@APOLOGIES_UNDERSTANDING.sample
            end
        end

        return {text: answer}
    end

    def detect_any_default_messages(msg)
        #implement fancier fuzzy string match!
        if Bot.fuzzy_string_match_array(msg, @@GREETINGS)
            #random_i = rand(0..@@GREETINGS.length - 1)
            return @@GREETINGS.sample
        elsif Bot.fuzzy_string_match_array(msg, @@GOODBYES)
            #random_i = rand(0..@@GOODBYES.length - 1)
            return @@GOODBYES.sample
        elsif Bot.fuzzy_string_match_array(msg, @@EXISTENTIAL_Q)
            #random_i = rand(0..@@EXISTENTIAL_A.length - 1)
            return @@EXISTENTIAL_A.sample
        elsif Bot.fuzzy_string_match_array(msg, @@EASY_QUESTIONS)
            #random_i = rand(0..@@EASY_ANSWERS.length - 1)
            return @@EASY_ANSWERS.sample
        else
            return nil
        end
    end

    def classify(msg)
        c = Classifier.find_by(bot_id: self.id)
        if c.nil?
            return nil
        end
        classifier = Marshal.load(c.saved)
        result = classifier.classify_with_score(msg)
        #byebug
        if result[1] > -10
            category = ""
            if result[0] == "Category 1"
                category = self.classifier.category_1
            else
                category = self.classifier.category_2
            end
            
            # length = self.classifier_responses.where(category: category).length
            # random_i = rand(0..length - 1)
            return self.classifier_responses.where(category: category).sample.text
        else
            return nil
        end
        
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
            if Bot.fuzzy_string_match(msg, string)
                return true
            end
        end
        return false
    end

    def self.clean_word(string)
        return string.downcase.gsub(/[^0-9a-z]/i, '')
    end

    def training(data)
        #example data:{"category1"=>"a", "category2"=>"b", "data1"=>"aa", "data2"=>"bb", "responses"=><ActionController::Parameters{"responses1"=>["aha", "oho"], "responses2"=>["b/bye"]}
        
        #find if this bot has a classifier already
        #if have a classifier, delete that one and all the classifier_responses
        if self.classifier
            self.classifier.destroy
        end
        #create a new classifier with those two categories
        classifier = ClassifierReborn::Bayes.new('Category 1', 'Category 2')
        #train your classifier with the training data
        classifier.train_category_1(data[:data1])
        classifier.train_category_2(data[:data2])
        puts classifier
        #save the classifier back to the database with the categories, data and bot_id
        
        Classifier.create(
            bot: self, 
            saved: Marshal.dump(classifier), 
            category_1: data[:category1], 
            category_2: data[:category2], 
            data_1: data[:data1], 
            data_2: data[:data2]
            )
        #delete old responses
        ClassifierResponse.where(bot_id: self.id).destroy_all
        #save your responses to classifier_responses table with the bot_id
        data[:responses][:responses1].each do |response|
            ClassifierResponse.create(bot: self, category: data[:category1], text: response)
        end
        data[:responses][:responses2].each do |response|
            ClassifierResponse.create(bot: self, category: data[:category2], text: response)
        end

        
    end

end