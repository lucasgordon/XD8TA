Rails.application.routes.draw do
  root 'home#index'

  resources :users do
    member do
      get :posts
      get :fetch_posts_private_metrics
      get :fetch_posts_public_metrics
    end
  end

  get "sign_up" => "users#new", as: :sign_up

  resource :session, only: [:new, :create, :destroy]
  get "sign_in" => "sessions#new", as: :sign_in
  get "sign_out" => "sessions#destroy", as: :sign_out

  resources :posts
end
