# frozen_string_literal: true

require 'test_helper'

module Github
  class PullRequestsControllerTest < ActionDispatch::IntegrationTest
    setup do
      @user = users(:john)
      setup_omniauth_mock(@user)
      post "/login?uid=#{@user.uid}"
      @team = teams(:three)
      @app = apps(:three)
    end

    test 'should get index' do
      VCR.use_cassette('github/pull_requests_controller') do
        get team_app_github_repository_pull_requests_path(@team, @app, @app.github_repo_slug)
        assert_response :success
      end
    end

    # test 'should show github_pull_request' do
    #   VCR.use_cassette('github/pull_requests_controller', record: :new_episodes) do
    #     get team_app_github_repository_pull_request_path(@team, @app, @app.github_repo_slug, 1)
    #     assert_response :success
    #   end
    # end
  end
end
