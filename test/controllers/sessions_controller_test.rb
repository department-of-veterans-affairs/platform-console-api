# frozen_string_literal: true

require 'test_helper'

class SessionsControllerTest < ActionController::TestCase
  test 'log in success' do
    @user = users :john
    request.env['omniauth.auth'] = setup_omniauth_mock(@user)
    get :create
    response.request.path == '/'
  end

  test 'log in fail' do
    @user = users :joe
    request.env['omniauth.auth'] = setup_omniauth_mock(@user)
    get :create
    response.request.path == '/login'
  end
end
