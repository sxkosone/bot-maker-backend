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
end
