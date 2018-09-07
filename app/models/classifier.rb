#this is a training class for machine learning classifier

class Classifier < ApplicationRecord
    def train_moods
        goods = 
        "good
        acceptable
        bad
        nice
        excellent
        exceptional
        favorable
        great
        marvelous
        positive
        satisfactory
        satisfying
        superb
        valuable
        wonderful
        awesome
        ace
        boss"
        bads = 
        "atrocious
        awful
        cheap
        crummy
        dreadful
        lousy
        poor
        rough
        sad
        unacceptable"
        #here or elsewhere? create your classifier with categories for "good" and "bad"
        #retrieve the bytea representation of your classifier from database
        #c = Classifier.find(1).saved
        #cc = Marshal.load(c)
        #cc.train_good(goods)
        #cc.train_bad(bads)
        #c.saved = Marshal.dump(cc)
        #c.save
    end
end