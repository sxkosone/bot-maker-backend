class ResponsesController < ApplicationController

    def index
        #GET /triggers/:trigger_id/responses
        @responses = Response.where(trigger_id: params[:trigger_id])
        render json: @responses
    end

    def show
        #GET /responses/:id
        @response = Response.find(params[:id])
        render json: @response
    end
end
