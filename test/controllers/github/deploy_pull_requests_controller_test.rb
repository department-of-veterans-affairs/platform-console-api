# frozen_string_literal: true

require 'test_helper'

module Github
  class DeployPullRequestsControllerTest < ActionDispatch::IntegrationTest
    setup do
      @user = users(:jane)
      setup_omniauth_mock(@user)
      @team = teams(:three)
      @app = apps(:four)
    end

    test 'should create a deploy pull request' do
      VCR.use_cassette('github/deploy_pull_requests_controller') do
        # TODO: need to fix auth
        get github_oauth_callback_path(code: '1b5acd1175129a747f29')
        @user.reload
        post team_app_deploy_pull_requests_path(@team, @app)
        assert_redirected_to team_app_deploys_path
      end
    end
  end
end
