Rails.application.routes.draw do
  resources :users, only: [:create, :show] do
    #nested routes: users have triggers, triggers have responses
    resources :triggers, shallow: true do #may not need all routes for triggers!
      resources :responses, only: [:index, :show] #will I need more routes for responses?
    end
  end
  
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
