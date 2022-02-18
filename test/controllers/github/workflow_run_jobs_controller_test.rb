# frozen_string_literal: true

require 'test_helper'

module Github
  class WorkflowRunJobsControllerTest < ActionDispatch::IntegrationTest
    setup do
      @user = users(:john)
      setup_omniauth_mock(@user)
      post "/login?uid=#{@user.uid}"
      @team = teams(:three)
      @app = apps(:three)
    end

    test 'should show workflow_run_job' do
      VCR.use_cassette('github/workflow_run_jobs_controller') do
        get team_app_github_repository_workflow_workflow_run_workflow_run_job_path(@team, @app, @app.github_repo_slug,
                                                                                   7_426_309,
                                                                                   1_848_333_333, 5_204_164_825)
        assert_response :success
      end
    end
  end
end
