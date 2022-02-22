# frozen_string_literal: true

require 'test_helper'

module Github
  class WorkflowsControllerTest < ActionDispatch::IntegrationTest
    setup do
      @user = users(:john)
      setup_omniauth_mock(@user)
      @team = teams(:three)
      @app = apps(:three)
    end

    test 'should get index' do
      VCR.use_cassette('github/workflows_controller') do
        get team_app_github_repository_workflows_path(@team, @app, @app.github_repo)
        assert_response :success
      end
    end

    test 'should show github_workflow' do
      VCR.use_cassette('github/workflows_controller', record: :new_episodes) do
        get team_app_github_repository_workflow_path(@team, @app, @app.github_repo, 7_426_309)
        assert_response :success
      end
    end
  end
end