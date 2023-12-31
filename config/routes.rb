# frozen_string_literal: true

Rails.application.routes.draw do
  devise_for :users
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get 'up' => 'rails/health#show', as: :rails_health_check

  resources :home, only: :index
  resources :reservations, only: %i[index show update], param: :reservation_token
  namespace :books do
    resources :search, only: :index
  end
  resources :books, only: %i[show] do
    resources :reservations, only: :create, controller: 'books/reservations'
  end

  # Defines the root path route ("/")
  root 'home#index'
end
