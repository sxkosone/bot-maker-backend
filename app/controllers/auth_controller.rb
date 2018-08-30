class AuthController < ApplicationController

    skip_before_action :authenticate, only: [:login]
  
    # post to /login with { username: 'some name', password: 'some password' }
    def login
      user = User.find_by(username: params[:username])
      if user && user.authenticate(params[:password])
        token = encode({user_id: user.id})
        render json: { token: token, success: true }
      else
        render json: { success: false }, status: 401
      end
    end
  end