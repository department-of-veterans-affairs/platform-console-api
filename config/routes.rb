# frozen_string_literal: true

require 'sidekiq/web'
require 'authenticatable_constraint'

# rubocop:disable Metrics/BlockLength
Rails.application.routes.draw do
  mount Rswag::Ui::Engine => '/api-docs'
  mount Rswag::Api::Engine => '/api-docs'
  resources :users, only: %i[show edit update]
  post '/users/:id/api-keys', to: 'users#create_api_key'
  delete '/users/:id/api-keys/:api_key_id', to: 'users#destroy_api_key'
  resources :audits, only: [:index]

  scope module: :api do
    namespace :v1 do
      resources :users, only: %i[show edit update]
      resources :teams do
        resources :apps do
          resources :deploy_pull_requests, only: %i[create], controller: 'github/deploy_pull_requests'
          resources :pull_requests, only: %i[index], controller: 'github/pull_requests'
          resources :workflows, only: %i[index show], controller: 'github/workflows'
          resources :workflow_runs, controller: 'github/workflow_runs'
          resources :workflow_run_jobs, only: [:show], controller: 'github/workflow_run_jobs'
          resources :deploys, only: %i[index show], controller: 'github/workflows'
          resources :deploy_runs, controller: 'github/workflow_runs'
          resources :deploy_run_jobs, only: [:show], controller: 'github/workflow_run_jobs'
          get 'repository', controller: 'github/repositories', action: :show
          resources :deployments
        end
      end
    end
  end

  resources :teams do
    resources :apps do
      scope :v0 do
        resources :deploy_pull_requests, only: %i[create], controller: 'github/deploy_pull_requests'
        resources :pull_requests, only: %i[index], controller: 'github/pull_requests'
        resources :workflows, only: %i[index show], controller: 'github/workflows'
        resources :workflow_runs, controller: 'github/workflow_runs'
        resources :workflow_run_jobs, only: [:show], controller: 'github/workflow_run_jobs'
        resources :deploys, only: %i[index show], controller: 'github/workflows'
        resources :deploy_runs, controller: 'github/workflow_runs'
        resources :deploy_run_jobs, only: [:show], controller: 'github/workflow_run_jobs'
      end
      resources :deployments
    end
  end

  get '/github/oauth/callback' => 'github/oauth#callback'
  delete '/github/oauth/revoke' => 'github/oauth#revoke'

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

    delete '/api-keys', to: 'api_keys#destroy'
    get '/api-keys', to: 'api_keys#index'
  end
end
# rubocop:enable Metrics/BlockLength
