class TriggersController < ApplicationController
    #these first two routes not really used so commenting them out to see if they can be deleted
    # def index
    #     #get all that users triggers
    #     #route GET /users/:user_id/triggers
    #     @triggers = Trigger.where(user_id: params[:user_id])
    #     render json: @triggers
    # end

    # def show
    #     #route GET /triggers/:id
    #     @trigger = Trigger.find(params[:id])
    #     render json: @trigger
    # end

    def find_answer
        #POST '/find-answer'
        #TODO change this to use Bot model to retrieve responses
        bot_url_id = params[:bot_url_id]
        @bot = Bot.find_by(url_id: bot_url_id)
        
        #case1: user doesn't have default script detection on
        #only recognises exact trigger matches, else returns "I don't understand"
        #case2: recognises general greetings and greets back if no exact trigger matches. Fallback "I don't understand" still there
        answer = @bot.respond_to_message(params[:user_message], params[:message_history], @bot.include_default_scripts)
        
        render json: answer
    end

end
