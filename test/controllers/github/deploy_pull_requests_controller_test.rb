# frozen_string_literal: true

require 'test_helper'

module Github
  class DeployPullRequestsControllerTest < ActionDispatch::IntegrationTest
    setup do
      @user = users(:john)
      setup_omniauth_mock(@user)
      @team = teams(:three)
      @app = apps(:four)
    end

    test 'should create a deploy pull request' do
      VCR.use_cassette('github/deploy_pull_requests_controller', allow_playback_repeats: true) do
        post team_app_v0_deploy_pull_requests_path(@team, @app)
        assert_redirected_to team_app_v0_deploys_path
        assert_equal 'Pull Request has been created.', flash.notice
      end
    end
  end
end
