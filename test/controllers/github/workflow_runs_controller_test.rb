# frozen_string_literal: true

require 'test_helper'

module Github
  class WorkflowRunsControllerTest < ActionDispatch::IntegrationTest
    setup do
      @user = users(:john)
      setup_omniauth_mock(@user)
      @team = teams(:three)
      @app = apps(:four)
    end

    test 'should get index' do
      VCR.use_cassette('github/workflow_runs_controller', record: :new_episodes) do
        get team_app_workflow_runs_path(@team, @app)
        assert_response :success
      end
    end

    test 'should get index in json format' do
      VCR.use_cassette('github/workflow_runs_controller', record: :new_episodes) do
        get "#{team_app_workflow_runs_path(@team, @app)}.json"
        assert_response :success
        json_response = JSON.parse(response.body)
        expected_keys = %w[id name node_id head_branch head_sha run_number event status conclusion workflow_id
                           check_suite_id check_suite_node_id url html_url pull_requests created_at updated_at
                           run_attempt run_started_at jobs_url logs_url check_suite_url artifacts_url cancel_url
                           rerun_url previous_attempt_url workflow_url head_commit repository head_repository]
        assert(expected_keys.all? { |k| json_response['workflow_runs'].first.key? k })
      end
    end

    test 'should show workflow run' do
      VCR.use_cassette('github/workflow_runs_controller', record: :new_episodes) do
        get team_app_workflow_run_path(@team, @app, 1_960_262_366)
        assert_response :success
      end
    end

    test 'should show workflow run in json format' do
      VCR.use_cassette('github/workflow_runs_controller') do
        get "#{team_app_workflow_run_path(@team, @app, 1_960_262_366)}.json"
        assert_response :success
        json_response = JSON.parse(response.body)
        expected_keys = %w[id name node_id head_branch head_sha run_number event status conclusion workflow_id
                           check_suite_id check_suite_node_id url html_url pull_requests created_at updated_at
                           run_attempt run_started_at jobs_url logs_url check_suite_url artifacts_url cancel_url
                           rerun_url previous_attempt_url workflow_url head_commit repository head_repository]
        assert(expected_keys.all? { |k| json_response['workflow_run'].key? k })
        assert_equal 1_960_262_366, json_response['workflow_run']['id']
      end
    end

    test 'should rerun workflow' do
      VCR.use_cassette('github/workflow_runs_controller', record: :new_episodes) do
        patch team_app_workflow_run_path(@team, @app, 1_960_262_366)
        assert_equal 'Workflow run was sucessfully restarted', flash.notice
        assert_redirected_to team_app_workflow_path(@team, @app, 17_962_379)
      end
    end
  end
end
