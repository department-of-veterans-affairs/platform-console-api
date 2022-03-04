# frozen_string_literal: true

require 'sidekiq/web'
require 'authenticatable_constraint'

# rubocop:disable Metrics/BlockLength
Rails.application.routes.draw do
  resources :users, only: %i[show edit update]
  resources :audits, only: [:index]

  resources :teams do
    resources :apps do
      resources :deploy_pull_requests, only: %i[create], controller: 'github/deploy_pull_requests'
      resources :pull_requests, only: %i[index], controller: 'github/pull_requests'
      resources :workflows, only: %i[index show], controller: 'github/workflows' do
        get :new_dispatch, on: :collection
        post :workflow_dispatch, on: :collection
      end
      resources :workflow_runs, only: %i[index show], controller: 'github/workflow_runs' do
        post :rerun, on: :member
      end
      resources :workflow_run_jobs, only: [:show], controller: 'github/workflow_run_jobs'

      resources :deploys, only: %i[index show new], controller: 'github/deploys' do
        post :create, on: :collection
      end
      resources :deploy_runs, only: [:show], controller: 'github/deploy_runs' do
        post :rerun, on: :member
      end
      resources :deploy_run_jobs, only: [:show], controller: 'github/deploy_run_jobs'
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
  end
end
# rubocop:enable Metrics/BlockLength
