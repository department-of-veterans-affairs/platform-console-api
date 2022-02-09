# frozen_string_literal: true

require 'test_helper'

module GitHub
  class WorkflowRunTest < ActionDispatch::IntegrationTest
    test 'can be created with a valid repo and workflow_run id' do
      VCR.use_cassette('git_hub/workflow_run') do
        workflow_run = GitHub::WorkflowRun.new('vets-api', '1815728096')
        assert_instance_of GitHub::WorkflowRun, workflow_run
        assert_instance_of Sawyer::Resource, workflow_run.gh_info
        assert_equal 1_815_728_096, workflow_run.gh_info.id
      end
    end

    test 'extracting logs' do
      VCR.use_cassette('git_hub/workflow_run_logs') do
        workflow_run_id = GitHub::WorkflowRun.all('vets-api').workflow_runs.last.id
        workflow_run = GitHub::WorkflowRun.new('vets-api', workflow_run_id)
        assert_not_nil workflow_run.gh_info.run_number
      end
    end
  end
end
