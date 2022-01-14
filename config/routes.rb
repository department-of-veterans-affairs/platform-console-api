# frozen_string_literal: true

require 'sidekiq/web'
require 'authenticatable_constraint'

Rails.application.routes.draw do
  root 'pages#home'

  # Session
  get '/login' => 'sessions#new'
  post '/login' => 'sessions#create'
  get '/logout' => 'sessions#destroy'

  # Sidekiq
  constraints ->(request) { AuthenticatableConstraint.new(request).current_user&.admin? } do
    mount Sidekiq::Web => '/sidekiq'
  end
end
