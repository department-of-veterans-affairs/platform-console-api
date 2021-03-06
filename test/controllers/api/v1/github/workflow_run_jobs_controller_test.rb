# frozen_string_literal: true

require 'test_helper'

module V1
  module Github
    class WorkflowRunJobsControllerTest < ActionDispatch::IntegrationTest
      setup do
        host! 'test.host'
        @user = users(:john)
        @team = teams(:three)
        @app = apps(:three)
      end

      test 'should show workflow run job' do
        VCR.use_cassette('api/github/workflow_run_jobs_controller') do
          get v1_team_app_workflow_run_job_path(@team, @app, 5_204_164_825), headers: api_auth_header(@user)
          assert_response :success
        end
      end
    end
  end
end
