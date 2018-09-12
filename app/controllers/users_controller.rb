class UsersController < ApplicationController
    before_action :authenticate, only: [:show, :update]

    def index
        @users = User.all
        render json: @users
    end

    def get_user
        #GET /user
        render json: { 
            id: current_user.id,
            username: current_user.username, 
            bots: current_user.bots
        }
    end

    def create
        #creating a new user shouldn't be authenticated
        #POST /users
        #example: user={username: "lisa", bot_name: "lisabot", triggers: [{text:"hi", responses: ["hi!", "hey"]}]}
        
        #first, create a user
        @user = User.new(username: user_params[:username], password: user_params[:password])
        
        if @user.valid?
            @user.save
            #@bot.save
            puts "created user #{@user.username}"
            render json: {success: true, user: @user}
        else
            render json: {success: false, errors: @user.errors.messages}
        end 
    end

    def update
        #PATCH /users/:id
        #TODO update bots scripts too!
        #this is authenticated before hitting this route
        #user adds new scripts
        @user = User.find_by(username: user_params[:username])
        @bot = Bot.find_or_create_by(user_id: @user.id, url_id: user_params[:bot_url_id])
        unless user_params[:bot_name].nil? 
            @bot.name = user_params[:bot_name]
        end
        
        @bot.url_id = user_params[:bot_url_id]
        @bot.description = user_params[:bot_description]
        
        #double check if this working, shoudl be!!!
        @bot.include_default_scripts = user_params[:include_default_scripts]
        @bot.include_classifier = user_params[:include_classifier]
        @bot.save
        #iterate through params to create triggers AND their responses
        unless user_params[:triggers] == nil
            @bot.triggers.destroy_all
            user_params[:triggers].each do |trigger|
                new_trigger = Trigger.create(text: trigger[:text], bot: @bot)
                trigger[:responses].each do |response|
                    new_response = Response.create(text: response[:text], trigger: new_trigger)
                end
            end
        end
        #create fallbacks from non-strong params
        
        unless params[:user][:fallback] == nil
            @bot.fallbacks.destroy_all
            params[:user][:fallback].each do |f|
                new_fallback = Fallback.create(text: f, bot: @bot)
                
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
        params.require(:user).permit(:username, :password, :bot_name, :bot_url_id, :bot_description, :include_default_scripts, :include_classifier, triggers: [:text, responses:[:text]])
    end

end
