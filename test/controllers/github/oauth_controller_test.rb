# frozen_string_literal: true

require 'test_helper'

module Github
  class OauthControllerTest < ActionDispatch::IntegrationTest
    setup do
      @user = users(:jane)
      setup_omniauth_mock(@user)
      @team = teams(:three)
      @app = apps(:three)
    end

    test 'should get callback and set the token on user' do
      VCR.use_cassette('github/oauth_controller') do
        assert_nil @user.github_token
        get github_oauth_callback_path(code: '8844c746293e364b3a6a')
        assert_response :success
        @user.reload
        assert @user.github_token.present?
      end
    end

    test 'should revoke token on user' do
      VCR.use_cassette('github/oauth_controller', allow_playback_repeats: true) do
        get github_oauth_callback_path(code: '8844c746293e364b3a6a')
        @user.reload
        assert @user.github_token.present?
        delete github_oauth_revoke_path
        @user.reload
        assert_nil @user.github_token
        delete github_oauth_revoke_path
        assert_redirected_to edit_user_path(@user)
        assert_equal 'GitHub account successfully removed.', flash.notice
      end
    end
  end
end
