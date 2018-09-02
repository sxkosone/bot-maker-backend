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
        #route ??
        user_message = params[:user_message]
        bot_url_id = params[:bot_url_id]
        @user = User.find_by(bot_url_id: bot_url_id)
        
        answer = {answer: find_trigger_match(user_message, @user)}
        render json: answer
    end

    private
    def find_trigger_match(user_message, user)
        #byebug
        answer = {text: "I don't understand"}
        user.triggers.map do |trigger|
            if trigger.text == user_message
                answer = trigger.responses[0]
            end
        end
        return answer

    end
end
