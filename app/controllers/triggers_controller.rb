class TriggersController < ApplicationController


    def find_answer
        #POST '/find-answer'
        bot_url_id = params[:bot_url_id]
        @bot = Bot.find_by(url_id: bot_url_id)
        
        #case1: user doesn't have default script detection on
        #only recognises exact trigger matches, else returns "I don't understand"
        #case2: recognises general greetings and greets back if no exact trigger matches. Fallback "I don't understand" still there
        answer = @bot.respond_to_message(params[:user_message], params[:message_history], @bot.include_default_scripts)
        
        render json: answer
    end

end
