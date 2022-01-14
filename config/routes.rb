# frozen_string_literal: true

require 'sidekiq/web'
require 'authenticatable_constraint'

Rails.application.routes.draw do
  root 'pages#home'

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
