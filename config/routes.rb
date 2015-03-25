Rails.application.routes.draw do
  resources :tasks

  root 'home#index'end
