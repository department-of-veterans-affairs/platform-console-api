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

    test 'should get index in json format' do
      VCR.use_cassette('github/workflow_runs_controller') do
        get "#{team_app_github_repository_workflow_workflow_runs_path(@team, @app, @app.github_repo, 7_426_309)}.json"
        assert_response :success
        json_response = JSON.parse(response.body)
        expected_keys = %w[id name head_branch run_number event status conclusion workflow_id url workflow_url]
        assert(expected_keys.all? { |k| json_response.first.key? k })
      end
    end

    test 'should show workflow run' do
      VCR.use_cassette('github/workflow_runs_controller', record: :new_episodes) do
        get team_app_github_repository_workflow_workflow_run_path(@team, @app, @app.github_repo, 7_426_309,
                                                                  1_859_445_208)
        assert_response :success
      end
    end

    test 'should show workflow run in json format' do
      VCR.use_cassette('github/workflow_runs_controller') do
        get "#{team_app_github_repository_workflow_workflow_run_path(@team, @app, @app.github_repo, 7_426_309,
                                                                     1_859_445_208)}.json"
        assert_response :success
        json_response = JSON.parse(response.body)
        expected_keys = %w[id name head_branch run_number event status conclusion workflow_id url workflow_url]
        assert(expected_keys.all? { |k| json_response.key? k })
        assert_equal 1_859_445_208, json_response['id']
      end
    end
  end
end
