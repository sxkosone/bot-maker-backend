class ApplicationController < ActionController::API
    include ActionController::HttpAuthentication::Token::ControllerMethods

    #before_action :authenticate
    def current_user
        @current_user ||= authenticate
    end

    def authenticate
        #check if user is logged in AND that the token received from frontend matches
        authenticate_or_request_with_http_token do |token|
            begin
                decoded_token = decode(token)
                @current_user = User.find_by(id: decoded_token[0]["user_id"])
                #@current_user = User.find(decoded[0]["user_id"]) #could this work too?
            rescue JWT::DecodeError
                render json: { authorized: false }, status: 401
            end
        end
    end

    def secret_key
        return ENV["SECRET_KEY"]
    end

    def encode(payload)
        JWT.encode(payload, secret_key, 'HS256')
    end

    def decode(token)
        JWT.decode(token, secret_key, true, { algorithm: 'HS256' })
    end
end
