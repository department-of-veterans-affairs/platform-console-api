# frozen_string_literal: true

require 'test_helper'

module Github
  class WorkflowRunJobSerializerTest < ActionDispatch::IntegrationTest
    setup do
      @user = users(:john)
      @team = teams(:three)
      @app = apps(:three)
      VCR.use_cassette('github/workflow_run_job') do
        @workflow_run_job = Github::WorkflowRunJob.new(
          ENV.fetch('GITHUB_ACCESS_TOKEN'), 'department-of-veterans-affairs/vets-api', 5_169_530_176, @app.id
        )
        @hash = Github::WorkflowRunJobSerializer.new(@workflow_run_job).serializable_hash
      end
    end

    test 'should serialize with the correct attributes' do
      assert_equal @hash.dig(:data, :attributes).keys, %i[repo github app_id]
    end

    test 'should have the correct relationships' do
      assert_equal @hash.dig(:data, :relationships).keys, %i[workflow_run app]
    end

    test 'should have correct relationship links' do
      assert_equal @hash.dig(:data, :relationships, :workflow_run, :links, :related),
                   "test.host/api/v1/teams/#{@app.team_id}/apps/#{@app.id}/workflow_runs"

      assert_equal @hash.dig(:data, :relationships, :app, :links, :related),
                   "test.host/api/v1/teams/#{@app.team_id}/apps/#{@app.id}"
    end
  end
end
