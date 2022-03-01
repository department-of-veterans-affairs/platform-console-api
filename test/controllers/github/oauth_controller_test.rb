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
        get github_oauth_callback_path(code: '1b5acd1175129a747f29')
        assert_response :found
        @user.reload
        assert @user.github_token.present?
      end
    end
  end
end
