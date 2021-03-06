Rails.application.routes.draw do
  devise_for :users, controllers: { sessions: 'users/sessions' }
  root to: 'pages#home'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  resources :sources, only: [:index, :new, :create, :show, :edit, :destroy, :update] do
    resources :comments, only: [:create], as: "create_comment"
    resources :quotes, only: [:create]
  end


  resources :quotes, only: [:new, :create, :show]

  # post 'quotes/create/:quote', to: 'quotes#create', as: "quotes/create"


  resources :folders, only: [:show, :edit, :new, :create]

  resources :relationships, only: [:update, :destroy]

  post "relationships/:id", to: "relationships#create", as: "create_relationship"
  delete "relationship/:id", to: "relationships#destroy", as: "delete_relationship"

  get "user/:id/overview", to: "pages#user_profile_overview", as: "user_profile_overview"
  get "user/:id/followers", to: "pages#user_profile_followers", as: "user_profile_followers"
  get "user/:id/following", to: "pages#user_profile_following", as: "user_profile_following"

  namespace :api, defaults: { format: :json } do
    namespace :v1 do
      resources :quotes, only: [ :create ]
    end
  end

  get "search", to: "pages#search"

  resources :contacts, only: [:create]

end
