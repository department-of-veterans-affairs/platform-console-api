# frozen_string_literal: true

require 'test_helper'
module Api
  module V1
    module Github
      class DeployPullRequestsControllerTest < ActionDispatch::IntegrationTest
        setup do
          @user = users(:john)
          setup_omniauth_mock(@user)
          @team = teams(:three)
          @app = apps(:four)
        end

        test 'should create a deploy pull request' do
          VCR.use_cassette('api/github/deploy_pull_requests_controller', allow_playback_repeats: true) do
            post v1_team_app_deploy_pull_requests_path(@team, @app)
            assert_response :success
          end
        end
      end
    end
  end
end
