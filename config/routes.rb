Rails.application.routes.draw do
  resources :users, only: [:create, :show, :index, :update] do #take out index after development!
    #nested routes: users have triggers, triggers have responses
    resources :triggers, shallow: true do #may not need all routes for triggers!
    end
  end
  resources :bots, only: [:destroy]
  #logging in
  post '/login', to: "auth#login"
  get '/user', to: "users#get_user"

  get '/bots/:bot_url_id', to: "bots#show"
  post '/find-answer', to: "triggers#find_answer"
  post '/training/:bot_url_id', to: "bots#training"
  get '/classifier/:bot_url_id', to: "bots#classifier"
  
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
