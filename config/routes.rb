# frozen_string_literal: true

Rails.application.routes.draw do
  # get 'coaching/index'
  # resources :accounts do
  #   resources :tickets do
  #     resources :comments, only: %i[create destroy]
  #     resource :qa, controller: :qualities, except: :index do
  #       member do
  #         get 'acknowledgement', to: 'qualities#acknowledgement', as: 'acknowledgement'
  #       end
  #       resources :notes, module: :accounts, only: :create
  #     end
  #   end
# 
  #   # QA is block in this resources.
  #   authenticated :user, ->(user) { user.validate_coaching_access } do
  #     resources :coachings do
  #       resources :notes, module: :accounts, only: :create
  #       member do
  #         get 'acknowledgement', to: 'coachings#acknowledgement', as: 'acknowledgement'
  #       end
  #     end
  #   end
# 
  #   post 'join', on: :member
  #   post 'invite', on: :member
  #   delete 'leave', on: :member
  #   delete 'remove', on: :member
  # end

  # Route for the app subdomain
  constraints subdomain: 'internal' do
    # Add other app-specific routes here
    root 'accounts#index', as: :account_root
    resources :accounts do
      # post 'create', on: :collection
      resources :tickets do
        resources :comments, only: %i[create destroy]
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
      confirmations: 'users/confirmations',
      invitations: 'users/invitations',
      omniauth_callbacks: 'users/omniauth_callbacks'
    }
  end
  
  # Route for the app subdomain
  constraints subdomain: 'app' do
    root 'pages#home'
    # Add other app-specific routes here
  end
end
