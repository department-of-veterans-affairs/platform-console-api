# frozen_string_literal: true

require 'sidekiq/web'
require 'authenticatable_constraint'

Rails.application.routes.draw do
  resources :teams do
    resources :apps do
      namespace :git_hub do
        resources :repositories, only: [:show], param: :repo do
          resources :pull_requests, only: %i[index show], param: :number do
            resources :workflow_runs, only: [:index]
          end
          resources :issues, only: %i[index show], param: :number
          resources :workflows, only: %i[index show] do
            resources :workflow_runs, only: %i[index show] do
              post :rerun
            end
          end
        end
      end
    end
  end

  root to: redirect('/teams'), constraints: ->(request) { AuthenticatableConstraint.new(request).current_user.present? }
  root 'pages#home', as: :unauthenticated_root

  # Demo Page
  get '/demo', to: 'pages#demo'

  # Session
  get '/login' => 'sessions#new'
  post '/login' => 'sessions#create'
  get '/logout' => 'sessions#destroy'

  # Admin-only area
  constraints lambda { |request|
    Rails.env.development? || AuthenticatableConstraint.new(request).current_user&.has_role?(:admin)
  } do
    mount Flipper::UI.app(Flipper) => '/flipper'
    mount Sidekiq::Web => '/sidekiq'
  end
end
