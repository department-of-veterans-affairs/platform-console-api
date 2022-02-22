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

    test 'should get index in json format' do
      VCR.use_cassette('github/workflows_controller') do
        get "#{team_app_github_repository_workflows_path(@team, @app, @app.github_repo)}.json"
        assert_response :success
        json_response = JSON.parse(response.body)
        expected_keys = %w[id name state path created_at updated_at url]
        assert(expected_keys.all? { |k| json_response.first.key? k })
      end
    end

    test 'should show workflow' do
      VCR.use_cassette('github/workflows_controller', record: :new_episodes) do
        get team_app_github_repository_workflow_path(@team, @app, @app.github_repo, 7_426_309)
        assert_response :success
      end
    end

    test 'should show workflow in json format' do
      VCR.use_cassette('github/workflows_controller', record: :new_episodes) do
        get "#{team_app_github_repository_workflow_path(@team, @app, @app.github_repo, 7_426_309)}.json"
        assert_response :success
        json_response = JSON.parse(response.body)
        expected_keys = %w[id name state path created_at updated_at url]
        assert(expected_keys.all? { |k| json_response.key? k })
        assert_equal 7_426_309, json_response['id']
      end
    end
  end
end
