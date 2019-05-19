Rails.application.routes.draw do
  root to: "hotsprings#index"
  
  get "login", to: "sessions#new"
  post "login", to: "sessions#create"
  delete "logout", to: "sessions#destroy"
  
  get "signup", to: "users#new"

  get "hotspring/:code", to: "hotsprings#show"
  
  get "hotspring/:code/reviews/new", to: "reviews#new"
  get "hotspring/:code/reviews/:id", to: "reviews#show"
  get "hotspring/:code/reviews", to: "reviews#index"
  get "hotspring/:code/reviews/:id/edit", to: "reviews#edit"
  patch "hotspring/:code/reviews/:id", to: "reviews#update"
  post "hotspring/:code/reviews", to: "reviews#create"
  delete "hotspring/:code/reviews/:id", to: "reviews#destroy"

  resources :users
  resources :hotsprings, only: [:index, :create] do
    collection do
      post :search_cities
      post :search_districts
    end
  end
  resources :relationships, only: [:create, :destroy]

end
