# frozen_string_literal: true

Rails.application.routes.draw do
  get 'coaching/index'
  resources :accounts do
    resources :tickets do
      resource :qa, controller: :qualities, except: :index do
        member do
          get 'acknowledgement', to: 'qualities#acknowledgement', as: 'acknowledgement'
        end
        resources :notes, module: :accounts, only: :create
      end
    end

    # QA is block in this resources.
    authenticated :user, ->(user) { user.validate_coaching_access } do
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
