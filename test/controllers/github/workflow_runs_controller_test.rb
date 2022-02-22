# frozen_string_literal: true

require 'test_helper'

module Github
  class WorkflowRunsControllerTest < ActionDispatch::IntegrationTest
    setup do
      @user = users(:john)
      setup_omniauth_mock(@user)
      @team = teams(:three)
      @app = apps(:three)
    end

    test 'should get index' do
      VCR.use_cassette('github/workflow_runs_controller') do
        get team_app_github_repository_workflow_workflow_runs_path(@team, @app, @app.github_repo, 7_426_309)
        assert_response :success
      end
    end

    test 'should show github_workflow_run' do
      VCR.use_cassette('github/workflow_runs_controller', record: :new_episodes) do
        get team_app_github_repository_workflow_workflow_run_path(@team, @app, @app.github_repo, 7_426_309,
                                                                  1_859_445_208)
        assert_response :success
      end
    end
  end
end
