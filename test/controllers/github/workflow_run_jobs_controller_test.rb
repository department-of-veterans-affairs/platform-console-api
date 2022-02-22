# frozen_string_literal: true

require 'test_helper'

module Github
  class WorkflowRunJobsControllerTest < ActionDispatch::IntegrationTest
    setup do
      @user = users(:john)
      setup_omniauth_mock(@user)
      @team = teams(:three)
      @app = apps(:three)
    end

    test 'should show workflow run job' do
      VCR.use_cassette('github/workflow_run_jobs_controller') do
        get team_app_github_repository_workflow_workflow_run_workflow_run_job_path(@team, @app, @app.github_repo,
                                                                                   7_426_309,
                                                                                   1_848_333_333, 5_204_164_825)
        assert_response :success
      end
    end

    test 'should show workflow run job in json format' do
      VCR.use_cassette('github/workflow_run_jobs_controller') do
        get "#{team_app_github_repository_workflow_workflow_run_workflow_run_job_path(@team, @app, @app.github_repo,
                                                                                      7_426_309,
                                                                                      1_848_333_333,
                                                                                      5_204_164_825)}.json"
        assert_response :success
        json_response = JSON.parse(response.body)
        expected_keys = %w[id run_id status conclusion started_at completed_at steps url]
        assert(expected_keys.all? { |k| json_response.key? k })
        assert_equal 5_204_164_825, json_response['id']
        assert_equal 1_848_333_333, json_response['run_id']
      end
    end
  end
end
