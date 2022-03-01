# frozen_string_literal: true

require 'test_helper'

class UsersControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:jane)
    setup_omniauth_mock(@user)
    @team = teams(:one)
    @app = apps(:one)
  end

  test 'should show user' do
    get user_url(@user)
    assert_response :success
  end

  test 'should get edit' do
    get edit_user_url(@user)
    assert_response :success
  end

  test 'should update user' do
    patch user_url(@user), params: { user: { name: 'New Name' } }
    assert_redirected_to edit_user_url(@user)
  end
end
