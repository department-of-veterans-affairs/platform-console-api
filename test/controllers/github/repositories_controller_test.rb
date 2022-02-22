# frozen_string_literal: true

require 'test_helper'

module Github
  class RepositoriesControllerTest < ActionDispatch::IntegrationTest
    setup do
      @user = users(:john)
      setup_omniauth_mock(@user)
      @team = teams(:three)
      @app = apps(:three)
    end

    test 'should show repository' do
      VCR.use_cassette('github/repositories_controller') do
        get team_app_github_repository_path(@team, @app, @app.github_repo)
        assert_response :success
      end
    end

    test 'should show repository in json format' do
      VCR.use_cassette('github/repositories_controller') do
        get "#{team_app_github_repository_path(@team, @app, @app.github_repo)}.json"
        assert_response :success
        json_response = JSON.parse(response.body)
        expected_keys = %w[id name full_name description open_issues_count created_at updated_at url]
        assert(expected_keys.all? { |k| json_response.key? k })
        assert_equal @app.github_repo, json_response['name']
      end
    end
  end
end
