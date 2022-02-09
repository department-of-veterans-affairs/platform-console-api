# frozen_string_literal: true

require 'sidekiq/web'
require 'authenticatable_constraint'

Rails.application.routes.draw do
  resources :teams do
    resources :apps do
      namespace :git_hub do
        resources :repositories, only: [:show], param: :repo do
          resources :pull_requests, only: %i[index show]
          resources :workflows, only: %i[index show]
          resources :workflows_run, only: %i[index show] do
            post :rerun
          end
        end
      end
    end
  end

  root to: redirect('/teams'), constraints: ->(request) { AuthenticatableConstraint.new(request).current_user.present? }
  root 'pages#home', as: :unauthenticated_root

  # Session
  get '/login' => 'sessions#new'
  post '/login' => 'sessions#create'
  get '/logout' => 'sessions#destroy'

  # Admin-only area
  constraints ->(request) { Rails.env.development? || AuthenticatableConstraint.new(request).current_user&.admin? } do
    mount Flipper::UI.app(Flipper) => '/flipper'
    mount Sidekiq::Web => '/sidekiq'
  end
end
