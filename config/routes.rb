Rails.application.routes.draw do
  resources :users, only: [:create, :show, :index] do #take out index after development!
    #nested routes: users have triggers, triggers have responses
    resources :triggers, shallow: true do #may not need all routes for triggers!
      resources :responses, only: [:index, :show] #will I need more routes for responses?
    end
    #logging in
    post '/login', to: "auth#login"
  end
  
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
