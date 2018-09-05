class UsersController < ApplicationController
    before_action :authenticate, only: [:show]

    def index
        @users = User.all
        render json: @users
    end

    def get_user
        render json: { 
            id: current_user.id,
            username: current_user.username, 
            bot_name: current_user.bot_name, 
            bot_url_id: current_user.bot_url_id,
            include_default_scripts: current_user.include_default_scripts
        }
    end

    def get_bot
        #this is a public resource and should not be authenticated
        # GET /get-bot/:bot_url_id
        @user = User.find_by(bot_url_id: params[:bot_url_id])
        if @user.nil? 
            render json: {error: "No bot found in this address!"}
        end
        if @user.bot_name != nil && @user.bot_name != ""
            render json: {
                bot_name: @user.bot_name, 
                scripts: form_script(@user), 
                include_default_scripts: @user.include_default_scripts
            }
        else
            render json: {bot_name: "Anon-Bot", scripts: []}
        end
        
    end

    def create
        #creating a new user shouldn't be authenticated
        #POST /users
        #example: user={username: "lisa", bot_name: "lisabot", triggers: [{text:"hi", responses: ["hi!", "hey"]}]}
        
        #first, create a user
        @user = User.new(username: user_params[:username], password: user_params[:password], bot_name: user_params[:bot_name], bot_url_id: user_params[:bot_url_id])
        #iterate through params to create triggers AND their responses
        unless user_params[:triggers] == nil
            user_params[:triggers].each do |trigger|
                new_trigger = Trigger.create(text: trigger[:text], user: @user)
                trigger[:responses].each do |response|
                    new_response = Response.create(text: response[:text], trigger: new_trigger)
                end
            end
        end
        if @user.valid?
            @user.save
            puts "created user #{@user}"
            render json: {success: true, user: @user}
        else
            render json: {success: false, errors: @user.errors.messages}
        end 
    end

    def update
        #this is authenticated before hitting this route
        #user adds new scripts
        @user = User.find_by(username: user_params[:username])
        unless user_params[:bot_name].nil? 
            @user.bot_name = user_params[:bot_name]
        end
        unless user_params[:bot_url_id].nil?
            @user.bot_url_id = user_params[:bot_url_id]
        end
        #double check if this working, shoudl be!!!
        @user.include_default_scripts = user_params[:include_default_scripts]
        @user.save
        #iterate through params to create triggers AND their responses
        unless user_params[:triggers] == nil
            @user.triggers.destroy_all
            user_params[:triggers].each do |trigger|
                new_trigger = Trigger.create(text: trigger[:text], user: @user)
                trigger[:responses].each do |response|
                    new_response = Response.create(text: response[:text], trigger: new_trigger)
                end
            end
        end
        
        render json: @user
    end

    def show
        #this route will be deleted? no need after development?
        @user = User.find(params[:id])
        render json: @user

    end

    private
    def user_params
        params.require(:user).permit(:username, :password, :bot_name, :bot_url_id, :include_default_scripts, triggers: [:text, responses:[:text]])
    end

    def form_script(user)
        return user.triggers.map do |trigger| 
            {trigger: trigger.text, 
            response: trigger.responses.map do |res| 
                res.text end
            } 
        end
    end
end
