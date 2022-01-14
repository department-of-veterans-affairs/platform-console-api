# frozen_string_literal: true

Rails.application.routes.draw do
  root 'pages#home'

  # Session
  get '/login' => 'sessions#new'
  post '/login' => 'sessions#create'
  get '/logout' => 'sessions#destroy'
end
