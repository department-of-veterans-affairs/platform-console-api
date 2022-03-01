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
        get team_app_workflow_run_job_path(@team, @app, 5_204_164_825)
        assert_response :success
      end
    end

    test 'should show workflow run job in json format' do
      VCR.use_cassette('github/workflow_run_jobs_controller') do
        get "#{team_app_workflow_run_job_path(@team, @app, 5_204_164_825)}.json"
        assert_response :success
        json_response = JSON.parse(response.body)
        expected_keys = %w[id logs run_id run_url run_attempt node_id head_sha url html_url status conclusion
                           started_at completed_at name steps check_run_url labels runner_id runner_name runner_group_id
                           runner_group_name]
        assert(expected_keys.all? { |k| json_response['workflow_run_job'].key? k })
        assert_equal 5_204_164_825, json_response['workflow_run_job']['id']
        assert_equal 1_848_333_333, json_response['workflow_run_job']['run_id']
      end
    end
  end
end
