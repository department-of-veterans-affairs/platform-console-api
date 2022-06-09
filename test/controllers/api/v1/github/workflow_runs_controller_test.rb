# frozen_string_literal: true

require 'test_helper'

module V1
  module Github
    class WorkflowRunsControllerTest < ActionDispatch::IntegrationTest
      setup do
        @user = users(:john)
        setup_omniauth_mock(@user)
        @team = teams(:three)
        @app = apps(:four)
      end

      test 'should get index' do
        VCR.use_cassette('api/github/workflow_runs_controller', record: :new_episodes) do
          get v1_team_app_workflow_runs_path(@team, @app)
          assert_response :success
        end
      end

      test 'should show workflow run' do
        VCR.use_cassette('api/github/workflow_runs_controller', record: :new_episodes) do
          get v1_team_app_workflow_run_path(@team, @app, 2_471_421_620)
          assert_response :success
        end
      end

      test 'should rerun workflow' do
        VCR.use_cassette('api/github/workflow_runs_controller', record: :new_episodes) do
          patch v1_team_app_workflow_run_path(@team, @app, 2_471_421_620)
          assert_response :created
        end
      end
    end
  end
end
