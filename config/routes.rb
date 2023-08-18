# frozen_string_literal: true

Rails.application.routes.draw do
  resources :accounts do
    post 'join', on: :member
    post 'invite', on: :member
    delete 'leave', on: :member
    delete 'remove', on: :member
  end

  devise_for :users, controllers: {
    registrations: 'users/registrations',
    sessions: 'users/sessions',
    omniauth_callbacks: 'users/omniauth_callbacks'
  }

  root 'pages#home'
end
