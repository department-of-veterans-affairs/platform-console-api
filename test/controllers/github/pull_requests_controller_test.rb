# frozen_string_literal: true

require 'test_helper'

module Github
  class PullRequestsControllerTest < ActionDispatch::IntegrationTest
    setup do
      @user = users(:john)
      setup_omniauth_mock(@user)
      @team = teams(:three)
      @app = apps(:three)
    end

    test 'should get index' do
      VCR.use_cassette('github/pull_requests_controller') do
        get team_app_github_repository_pull_requests_path(@team, @app, @app.github_repo)
        assert_response :success
      end
    end

    test 'should get index in json format' do
      VCR.use_cassette('github/pull_requests_controller') do
        get "#{team_app_github_repository_pull_requests_path(@team, @app, @app.github_repo)}.json"
        assert_response :success
        json_response = JSON.parse(response.body)
        expected_keys = %w[id title number state body created_at updated_at url]
        assert(expected_keys.all? { |k| json_response.first.key? k })
      end
    end

    test 'should show pull request' do
      VCR.use_cassette('github/pull_requests_controller') do
        get team_app_github_repository_pull_requests_path(@team, @app, @app.github_repo, 2)
        assert_response :success
      end
    end
  end
end
