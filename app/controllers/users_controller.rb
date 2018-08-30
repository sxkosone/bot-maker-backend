class UsersController < ApplicationController
    def index
        @users = User.all
        render json: @users
    end

    def create
        #POST /users
        #example: user={username: "lisa", bot_name: "lisabot", triggers: [{text:"hi", responses: ["hi!", "hey"]}]}
        
        puts params
        #first, create a user
        @user = User.create(username: user_params[:username], bot_name: user_params[:bot_name], bot_url_id: user_params[:bot_url_id])
        #iterate through params to create triggers AND their responses
        user_params[:triggers].each do |trigger|
            new_trigger = Trigger.create(text: trigger[:text], user: @user)
            trigger[:responses].each do |response|
                new_response = Response.create(text: response[:text], trigger: new_trigger)
            end
        end
        render json: @user
    end

    def show
        @user = User.find(params[:id])
        render json: @user

    end

    private
    def user_params
        params.require(:user).permit(:username, :bot_name, :bot_url_id, triggers: [:text, responses:[:text]])
    end
end
