Rails.application.routes.draw do
  root 'home#index'

  resources :users, only: [:new, :show, :create, :edit, :update] do

  end

  resource :sessions, only: [:new, :create, :destroy]

  get "sign_up" => "users#new", as: :sign_up
  get "sign_in" => "sessions#new", as: :sign_in
  get "sign_out" => "sessions#destroy", as: :sign_out

  get "up" => "rails/health#show", as: :rails_health_check

  resources :posts

  get "initiate_fetch", to: "users#initiate_fetch", as: :initiate_fetch
  post "fetch_posts", to: "users#fetch_posts", as: :fetch_posts
end
