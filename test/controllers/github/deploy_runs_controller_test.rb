# frozen_string_literal: true

require 'test_helper'

module Github
  class DeployRunsControllerTest < ActionDispatch::IntegrationTest
    setup do
      @user = users(:john)
      setup_omniauth_mock(@user)
      @team = teams(:three)
      @app = apps(:four)
      Github.send :remove_const, 'DEPLOY_WORKFLOW_FILE'
      Github.const_set 'DEPLOY_WORKFLOW_FILE', 'codeql.yml'
    end

    test 'should show deploy run' do
      VCR.use_cassette('github/deploy_runs_controller', record: :new_episodes) do
        get team_app_deploy_run_path(@team, @app, 1_899_531_039)
        assert_response :success
      end
    end

    test 'should show deploy run in json format' do
      VCR.use_cassette('github/deploy_runs_controller') do
        get "#{team_app_deploy_run_path(@team, @app, 1_899_531_039)}.json"
        assert_response :success
        json_response = JSON.parse(response.body)
        expected_keys = %w[id name node_id head_branch head_sha run_number event status conclusion workflow_id
                           check_suite_id check_suite_node_id url html_url pull_requests created_at updated_at
                           run_attempt run_started_at jobs_url logs_url check_suite_url artifacts_url cancel_url
                           rerun_url previous_attempt_url workflow_url head_commit repository head_repository]
        assert(expected_keys.all? { |k| json_response['deploy_run'].key? k })
        assert_equal 1_899_531_039, json_response['deploy_run']['id']
      end
    end
  end
end
