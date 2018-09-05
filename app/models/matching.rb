#####
#NOT USED AT THE MOMENT!!
#####

class Matching
    @@GREETINGS = ["hi", "hey", "hello", "sup", "yo"]
    @@GOODBYES = ["bye", "byebye", "goodbye", "seeya"]
    @@EXISTENTIAL_Q = ["whatareyou", "whoareyou", "areyou", "howdoyouwork", "whatdoyoudo"]
    @@EXISTENTIAL_A = ["I am a friendly bot", "I am a chatbot", "I'm a chatbot, the kind humans can program on this website"]
    @@APOLOGIES_UNDERSTANDING = ["I can see I'm not understanding you very well", "There seems to be some misunderstanding here", "I know this is getting old, but I'm still not understanding", "I still don't understand you", "That's not something I know how to answer to"]

    #class has a native jaro winkler distance calculator instance for fuzzy string match
    #native is faster (than pure) but cannot handle special chars
    @@fuzzy_match = FuzzyStringMatch::JaroWinkler.create(:native)

    attr_accessor :history, :message, :user, :include_default_scripts

    def initialize(message, history, user, include_default_scripts=true)
        @message = Matching.clean_word(message)
        @history = history
        @user = user
        @include_default_scripts = include_default_scripts
    end

    def respond_to_message
        answer = nil
        #first check if any user triggers match message
        @user.triggers.map do |trigger|
            #implement fuzzy string matching
            clean_trigger = Matching.clean_word(trigger.text)
            if Matching.fuzzy_string_match(msg, clean_trigger)
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

        #bad understanding?
        return {text: answer}
    end

    def detect_any_default_messages(msg)
        #implement fancier fuzzy string match!
        if Matching.fuzzy_string_match_array(msg, @@GREETINGS)
            random_i = rand(0..@@GREETINGS.length - 1)
            return @@GREETINGS[random_i]
        elsif Matching.fuzzy_string_match_array(msg, @@GOODBYES)
            random_i = rand(0..@@GOODBYES.length - 1)
            return @@GOODBYES[random_i]
        elsif Matching.fuzzy_string_match_array(msg, @@EXISTENTIAL_Q)
            random_i = rand(0..@@EXISTENTIAL_A.length - 1)
            return @@EXISTENTIAL_A[random_i]
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
        #see if bot has said I dont understand in the last message
        if history[history.length-2] == "I'm sorry, I didn't understand that"
            return true
        else
            return false
        end
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

    def self.fuzzy_string_match_array(msg, array)
        #take an array of possible matches and look if message fuzzy matches any of them
        array.each do |string|
            if Matching.fuzzy_string_match(msg, string)
                return true
            end
        end
        return false
    end

    def self.clean_word(string)
        return string.downcase.gsub(/[^0-9a-z]/i, '')
    end

end