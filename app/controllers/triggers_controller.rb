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
        user_message = params[:user_message]
        bot_url_id = params[:bot_url_id]
        @user = User.find_by(bot_url_id: bot_url_id)
        
        #only recognises exact trigger matches, else returns "I don't understand"
        #answer = find_trigger_match(user_message, @user)
        
        #recognises general greetings and greets back if no exact trigger matches. Fallback "I don't understand still there"
        answer = @user.respond_to_message(user_message)
        render json: answer
    end

    private
    def find_trigger_match(user_message, user)
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
