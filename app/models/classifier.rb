#this is a training class for machine learning classifier

class Classifier < ApplicationRecord
    belongs_to :bot
    
        #this is how you reate your classifier with categories for "good" and "bad"
        #classifier = ClassifierReborn::Bayes.new('Good', 'Bad')
        #save_classifier = Marshal.dump(classifier)

        #retrieve the bytea representation of your classifier from database
        #c = Classifier.find(1).saved
        #cc = Marshal.load(c)
        #cc.train_good(goods)
        #cc.train_bad(bads)
        #c.saved = Marshal.dump(cc)
        #c.save

        #calling classifier methods
        #cc.classify("love")
    
end