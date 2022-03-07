# frozen_string_literal: true

require 'sidekiq/web'
require 'authenticatable_constraint'

Rails.application.routes.draw do
  resources :apps do
    resources :deployments
  end

  resources :audits, only: [:index]
  resources :teams do
    resources :apps
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
