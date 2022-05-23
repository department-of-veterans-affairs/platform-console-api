# frozen_string_literal: true

require 'test_helper'

module Github
  class WorkflowRunSerializerTest < ActionDispatch::IntegrationTest
    setup do
      @user = users(:john)
      @team = teams(:three)
      @app = apps(:three)
      VCR.use_cassette('github/workflow_run') do
        @workflow_run = Github::WorkflowRun.new(
          ENV['GITHUB_ACCESS_TOKEN'], 'department-of-veterans-affairs/vets-api', '1815728096', @app.id
        )
        @hash = Github::WorkflowRunSerializer.new(@workflow_run).serializable_hash
      end
    end

    test 'should serialize with the correct attributes' do
      assert_equal @hash.dig(:data, :attributes).keys, %i[repo github app_id]
    end

    test 'should have the correct relationships' do
      assert_equal @hash.dig(:data, :relationships).keys, %i[workflow workflow_run_jobs]
    end

    test 'should have correct relationship links' do
      assert_equal @hash.dig(:data, :relationships, :workflow, :links, :related),
                   "#{ENV['BASE_URL']}/api/v1/teams/#{@app.team_id}/apps/#{@app.id}/workflows/#{@workflow_run.workflow_id}"

      assert_equal @hash.dig(:data, :relationships, :workflow_run_jobs, :links, :related),
                   "#{ENV['BASE_URL']}/api/v1/teams/#{@app.team_id}/apps/#{@app.id}/workflow_run_jobs"
    end
  end
end
