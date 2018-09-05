class TriggersController < ApplicationController
    def index
        #get all that users triggers
        #route GET /users/:user_id/triggers
        @triggers = Trigger.where(user_id: params[:user_id])
        render json: @triggers
    end

    def show
        #route GET /triggers/:id
        @trigger = Trigger.find(params[:id])
        render json: @trigger
    end

    def find_answer
        #POST '/find-answer'
        message = params[:user_message]
        bot_url_id = params[:bot_url_id]
        @user = User.find_by(bot_url_id: bot_url_id)
        
        #case1: user doesn't have default script detection on
        #only recognises exact trigger matches, else returns "I don't understand"
        #case2: recognises general greetings and greets back if no exact trigger matches. Fallback "I don't understand" still there
        answer = @user.respond_to_message(message, @user.include_default_scripts)
        
        render json: answer
    end

    private
    def find_exact_trigger_match(user_message, user)
        answer = {text: "I don't understand"}
        user.triggers.map do |trigger|
            if trigger.text == user_message
                random_index = rand(0..trigger.responses.length-1)
                answer = {text: trigger.responses[random_index].text}
            end
        end
        return answer
    end

end
