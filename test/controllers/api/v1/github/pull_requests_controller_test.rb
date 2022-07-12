# frozen_string_literal: true

require 'test_helper'

module V1
  module Github
    class PullRequestsControllerTest < ActionDispatch::IntegrationTest
      setup do
        @user = users(:john)
        setup_omniauth_mock(@user)
        @team = teams(:three)
        @app = apps(:three)
      end

      test 'should get index' do
        VCR.use_cassette('api/github/pull_requests_controller') do
          get v1_team_app_pull_requests_url(@team, @app)
          assert_response :success
        end
      end
    end
  end
end
