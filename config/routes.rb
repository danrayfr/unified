# frozen_string_literal: true

Rails.application.routes.draw do
  get 'coaching/index'
  resources :accounts do
    resources :tickets

    # QA is block in this resources.
    authenticated :user, ->(user) { user.admin? || user.manager? || user.agent? } do
      resources :coachings do
        resources :notes, module: :accounts, only: :create
        member do
          get 'acknowledgement', to: 'coachings#acknowledgement', as: 'acknowledgement'
        end
      end
    end

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
