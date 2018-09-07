class BotsController < ApplicationController
    def show
        #used to be GET /get-bot/:bot_url_id
        #this is a public resource and should not be authenticated
        
        @bot = Bot.find_by(url_id: params[:bot_url_id])
        if @bot.nil? 
            render json: {error: "No bot found in this address!"}
        else
            if @bot.name != nil && @bot.name != ""
                render json: {
                    bot_name: @bot.name,
                    description: @bot.description,
                    scripts: form_script(@bot), 
                    include_default_scripts: @bot.include_default_scripts
                }
            else
                render json: {bot_name: "Anon-Bot", scripts: []}
            end
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
