# frozen_string_literal: true

require 'test_helper'

module Github
  class WorkflowSerializerTest < ActionDispatch::IntegrationTest
    setup do
      @user = users(:john)
      @team = teams(:three)
      @app = apps(:three)
      VCR.use_cassette('github/workflow') do
        @workflow = Github::Workflow.new(
          ENV['GITHUB_ACCESS_TOKEN'], 'department-of-veterans-affairs/vets-api', '13418388', @app.id
        )
        @hash = Github::WorkflowSerializer.new(@workflow).serializable_hash
      end
    end

    test 'should serialize with the correct attributes' do
      assert_equal @hash.dig(:data, :attributes).keys, %i[repo github app_id]
    end

    test 'should have the correct relationships' do
      assert_equal @hash.dig(:data, :relationships).keys, %i[app workflow_runs]
    end

    test 'should have correct relationship links' do
      assert_equal @hash.dig(:data, :relationships, :workflow_runs, :links, :related),
                   "/api/v1/teams/#{@app.team_id}/apps/#{@app.id}/workflow_runs"

      assert_equal @hash.dig(:data, :relationships, :app, :links, :related),
                   "/api/v1/teams/#{@app.team_id}/apps/#{@app.id}"
    end
  end
end
