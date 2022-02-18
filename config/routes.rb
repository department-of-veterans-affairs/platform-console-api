# frozen_string_literal: true

require 'sidekiq/web'
require 'authenticatable_constraint'

# rubocop:disable Metrics/BlockLength
Rails.application.routes.draw do
  resources :audits, only: [:index]
  resources :teams do
    resources :apps do
      namespace :github do
        resources :repositories, only: [:show], param: :repo do
          resources :pull_requests, only: %i[index show], param: :number
          resources :workflows, only: %i[index show] do
            collection do
              get :new_dispatch
              post :workflow_dispatch
            end
            resources :workflow_runs, only: %i[index show] do
              member do
                post :rerun
              end
              resources :workflow_run_jobs, only: [:show]
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
  get '/auth/keycloak/callback', to: 'omniauth#keycloak_openid'

  # Admin-only area
  constraints lambda { |request|
    Rails.env.development? || AuthenticatableConstraint.new(request).current_user&.has_role?(:admin)
  } do
    mount Flipper::UI.app(Flipper) => '/flipper'
    mount Sidekiq::Web => '/sidekiq'
  end
end
# rubocop:enable Metrics/BlockLength
