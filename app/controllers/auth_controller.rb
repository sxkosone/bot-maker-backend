class AuthController < ApplicationController

    #skip_before_action :authenticate, only: [:login]
    #should also have sign up here? or in the user's controller

    # post to /login with { username: 'some name', password: 'some password' }
    def login
      user = User.find_by(username: params[:username])
      if user && user.authenticate(params[:password])
        token = encode({user_id: user.id})
        
        render json: { token: token, success: true, current_user: user }
      else
        render json: { success: false }, status: 401
      end
    end
  end