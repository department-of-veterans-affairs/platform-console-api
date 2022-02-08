# frozen_string_literal: true

require 'test_helper'

module GitHub
  class WorkflowRunTest < ActionDispatch::IntegrationTest
    test 'extracting logs' do
      VCR.use_cassette('git_hub/workflow_run_logs') do
        workflow_run_id = GitHub::WorkflowRun.all('vets-api').workflow_runs.last.id
        workflow_run = GitHub::WorkflowRun.new('vets-api', workflow_run_id)
        assert_not_nil workflow_run.gh_info.run_number
      end
    end
  end
end
