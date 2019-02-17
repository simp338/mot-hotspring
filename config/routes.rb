Rails.application.routes.draw do
  root to: "hotsprings#index"
  
  get "login", to: "sessions#new"
  post "login", to: "sessions#create"
  delete "logout", to: "sessions#destroy"
  
  get "signup", to: "users#new"

  get "hotspring/:code", to: "hotsprings#show"

  resources :users
  resources :hotsprings, only: [:index, :create] do
    collection do
      post :search_cities
      post :search_districts
    end
  end
  resources :relationships, only: [:create, :destroy]
end
