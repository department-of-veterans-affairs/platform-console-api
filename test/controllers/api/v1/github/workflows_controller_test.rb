# frozen_string_literal: true

require 'test_helper'

module V1
  module Github
    class WorkflowsControllerTest < ActionDispatch::IntegrationTest
      setup do
        host! 'test.host'
        @user = users(:john)
        @team = teams(:three)
        @app = apps(:three)
      end

      test 'should get index' do
        VCR.use_cassette('api/github/workflows_controller', record: :new_episodes) do
          get v1_team_app_workflows_path(@team, @app), headers: api_auth_header(@user)
          assert_response :success
        end
      end

      test 'should get deploys' do
        VCR.use_cassette('api/github/workflows_controller', record: :new_episodes) do
          get v1_team_app_deploys_path(@team, @app), headers: api_auth_header(@user)
          assert_response :success
        end
      end

      test 'should show workflow' do
        VCR.use_cassette('api/github/workflows_controller', record: :new_episodes) do
          get v1_team_app_workflow_path(@team, @app, 7_426_309), headers: api_auth_header(@user)
          assert_response :success
        end
      end

      test 'should show deploy' do
        VCR.use_cassette('api/github/workflows_controller', record: :new_episodes) do
          get v1_team_app_deploy_path(@team, @app, 7_426_309), headers: api_auth_header(@user)
          assert_response :success
        end
      end
    end
  end
end
