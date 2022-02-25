# frozen_string_literal: true

require 'test_helper'

module Github
  class DeployRunJobsControllerTest < ActionDispatch::IntegrationTest
    setup do
      @user = users(:john)
      setup_omniauth_mock(@user)
      @team = teams(:three)
      @app = apps(:four)
      Github.send :remove_const, 'DEPLOY_WORKFLOW_FILE'
      Github.const_set 'DEPLOY_WORKFLOW_FILE', 'codeql.yml'
    end

    test 'should show deploy run job' do
      VCR.use_cassette('github/deploy_run_jobs_controller') do
        get team_app_deploy_run_job_path(@team, @app, 5_335_975_980)
        assert_response :success
      end
    end

    test 'should show deploy run job in json format' do
      VCR.use_cassette('github/deploy_run_jobs_controller') do
        get "#{team_app_deploy_run_job_path(@team, @app, 5_335_975_980)}.json"
        assert_response :success
        json_response = JSON.parse(response.body)
        expected_keys = %w[id logs run_id run_url run_attempt node_id head_sha url html_url status conclusion
                           started_at completed_at name steps check_run_url labels runner_id runner_name runner_group_id
                           runner_group_name]
        assert(expected_keys.all? { |k| json_response['deploy_run_job'].key? k })
        assert_equal 5_335_975_980, json_response['deploy_run_job']['id']
        assert_equal 1_899_531_039, json_response['deploy_run_job']['run_id']
      end
    end
  end
end
