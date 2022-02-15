# frozen_string_literal: true

require 'test_helper'

module GitHub
  class WorkflowRunTest < ActiveSupport::TestCase
    setup do
      VCR.use_cassette('git_hub/workflow_run') do
        @workflow_run = GitHub::WorkflowRun.new('vets-api', '1815728096')
      end
    end

    test 'can be created with a valid repo and workflow_run id' do
      assert_instance_of GitHub::WorkflowRun, @workflow_run
      assert_instance_of Sawyer::Resource, @workflow_run.gh_info
      assert_equal 1_815_728_096, @workflow_run.gh_info.id
    end

    test 'extracting logs' do
      VCR.use_cassette('git_hub/workflow_run_logs') do
        workflow_run_id = GitHub::WorkflowRun.all('vets-api').workflow_runs.last.id
        workflow_run = GitHub::WorkflowRun.new('vets-api', workflow_run_id)
        assert_not_nil workflow_run.gh_info.run_number

        logs_url = workflow_run.logs_url
        assert_kind_of String, logs_url
      end
    end

    test 'lists all workflow runs for a repository' do
      VCR.use_cassette('git_hub/workflow_run', record: :new_episodes) do
        all_workflow_runs = GitHub::WorkflowRun.all('vets-api').workflow_runs
        assert_kind_of Array, all_workflow_runs
        assert_not_nil all_workflow_runs.first.workflow_id
      end
    end

    test 'lists all workflow runs for a branch on a repository' do
      VCR.use_cassette('git_hub/workflow_run', record: :new_episodes) do
        branch_runs = GitHub::WorkflowRun.all_for_branch('vets-api', 'master').workflow_runs
        assert_kind_of Array, branch_runs
        assert_not_nil branch_runs.first.workflow_id
        assert_equal 'master', branch_runs.first.head_branch
      end
    end

    test 'lists all workflow runs for a given workflow' do
      VCR.use_cassette('git_hub/workflow_run', record: :new_episodes) do
        workflow_runs = GitHub::WorkflowRun.all_for_workflow('vets-api', '13418388').workflow_runs
        assert_kind_of Array, workflow_runs
        assert_equal 13_418_388, workflow_runs.first.workflow_id
      end
    end
  end
end
