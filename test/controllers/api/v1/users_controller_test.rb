# frozen_string_literal: true

require 'test_helper'

module Api
  module V1
    class UsersControllerTest < ActionDispatch::IntegrationTest
      setup do
        @user = users(:john)
        setup_omniauth_mock(@user)
        @team = teams(:three)
        @app = apps(:three)
      end

      test 'should show user' do
        get v1_user_url(@user)
        assert_equal @user.id, @response.parsed_body.dig('data', 'id').to_i
        assert_response :success
      end

      test 'should update user with valid params' do
        patch v1_user_url(@user), params: { user: { name: 'New Name' } }
        assert_response :ok
      end

      test 'should not update user with invalid params' do
        patch v1_user_url(@user), params: { user: { name: nil } }
        assert_response :unprocessable_entity
      end
    end
  end
end
