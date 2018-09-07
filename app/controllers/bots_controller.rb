class BotsController < ApplicationController
    before_action :authenticate, only: [:destroy]    
    
    def show
        #GET /bots/:url_id
        #used to be GET /get-bot/:bot_url_id
        #this is a public resource and should not be authenticated
        
        @bot = Bot.find_by(url_id: params[:bot_url_id])
        if @bot.nil? 
            render json: {success: false, error: "No bot found in this address!"}
        else
            if @bot.name != nil && @bot.name != ""
                render json: {
                    success: true,
                    bot_name: @bot.name,
                    description: @bot.description,
                    scripts: form_script(@bot), 
                    include_default_scripts: @bot.include_default_scripts
                }
            else
                render json: {success: true, bot_name: "Anon-Bot", scripts: []}
            end
        end
    end

    def destroy
        @bot = Bot.find(params[:id])
        user = User.find(@bot.user.id)
        user_obj = {username: user.username, bots: user.bots}
        if @bot.nil? 
            render json: {success: false, message: "could not delete this bot"}
        else 
            @bot.destroy
            render json: {success: true, message: "bot deleted", user: user_obj}
        end
    end

    private
    def form_script(bot)
        return bot.triggers.map do |trigger| 
            {trigger: trigger.text, 
            response: trigger.responses.map do |res| 
                res.text end
            } 
        end
    end
end
