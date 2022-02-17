# frozen_string_literal: true

require 'test_helper'

module Github
  class RepositoriesControllerTest < ActionDispatch::IntegrationTest
    setup do
      @user = users(:john)
      post "/login?uid=#{@user.uid}"
      @team = teams(:three)
      @app = apps(:three)
    end

    test 'should get index' do
      VCR.use_cassette('github/repositories_controller') do
        get team_app_github_repository_path(@team, @app, @app.github_repo_slug)
        assert_response :success
      end
    end
  end
end
