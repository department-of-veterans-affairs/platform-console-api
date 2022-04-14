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
        get team_app_workflows_path(@team, @app)
        assert_response :success
      end
    end

    test 'should redirect index for deploys' do
      VCR.use_cassette('github/workflows_controller', record: :new_episodes) do
        get team_app_deploys_path(@team, @app)
        assert_response :found
      end
    end

    test 'should get index in json format' do
      VCR.use_cassette('github/workflows_controller') do
        get "#{team_app_workflows_path(@team, @app)}.json"
        assert_response :success
        json_response = JSON.parse(response.body)
        expected_keys = %w[id node_id name path state created_at updated_at url html_url badge_url]
        assert(expected_keys.all? { |k| json_response['workflows'].first.key? k })
      end
    end

    test 'should show workflow' do
      VCR.use_cassette('github/workflows_controller', record: :new_episodes) do
        get team_app_workflow_path(@team, @app, 7_426_309)
        assert_response :success
      end
    end

    test 'should show deploy' do
      VCR.use_cassette('github/workflows_controller', record: :new_episodes) do
        get team_app_deploy_path(@team, @app, 7_426_309)
        assert_response :success
      end
    end

    test 'should show workflow in json format' do
      VCR.use_cassette('github/workflows_controller', record: :new_episodes) do
        get "#{team_app_workflow_path(@team, @app, 7_426_309)}.json"
        assert_response :success
        json_response = JSON.parse(response.body)
        expected_keys = %w[id node_id name path state created_at updated_at url html_url badge_url]
        assert(expected_keys.all? { |k| json_response['workflow'].key? k })
        assert_equal 7_426_309, json_response['workflow']['id']
      end
    end
  end
end
