Rails.application.routes.draw do
  resources :analytics
  root 'home#index'

  resources :users do
    member do
      get :posts
      get :fetch_posts_private_metrics
      get :fetch_posts_public_metrics
      get :analytics
    end
  end

  resources :analytics_chats, only: [:create, :destroy, :new] do
    member do
      post :create_message
      get :reset_chat
    end
  end

  get "sign_up" => "users#new", as: :sign_up

  resource :session, only: [:new, :create, :destroy]
  get "sign_in" => "sessions#new", as: :sign_in
  get "sign_out" => "sessions#destroy", as: :sign_out

  resources :posts, only: [:show]
end
