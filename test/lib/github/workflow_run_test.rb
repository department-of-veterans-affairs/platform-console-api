# frozen_string_literal: true

require 'test_helper'

module Github
  class WorkflowRunTest < ActiveSupport::TestCase
    setup do
      VCR.use_cassette('github/workflow_run') do
        @workflow_run = Github::WorkflowRun.new(
          ENV['GITHUB_ACCESS_TOKEN'], 'department-of-veterans-affairs/vets-api', '1815728096'
        )
      end
    end

    test 'can be created with a valid repo and workflow_run id' do
      VCR.use_cassette('github/workflow_run', record: :new_episodes) do
        assert_instance_of Github::WorkflowRun, @workflow_run
        assert_instance_of Sawyer::Resource, @workflow_run.github
        assert_equal 1_815_728_096, @workflow_run.github.id
      end
    end

    test 'extracting logs' do
      VCR.use_cassette('github/workflow_run_logs') do
        workflow_run_id = Github::WorkflowRun.all(
          ENV['GITHUB_ACCESS_TOKEN'], 'department-of-veterans-affairs/vets-api', 1
        )[:objects].last.id

        workflow_run = Github::WorkflowRun.new(
          ENV['GITHUB_ACCESS_TOKEN'], 'department-of-veterans-affairs/vets-api', workflow_run_id, 1
        )

        assert_not_nil workflow_run.github.run_number
        logs_url = workflow_run.logs_url
        assert_kind_of String, logs_url
      end
    end

    test 'lists all workflow runs for a repository' do
      VCR.use_cassette('github/workflow_run', record: :new_episodes) do
        all_workflow_runs = Github::WorkflowRun.all(
          ENV['GITHUB_ACCESS_TOKEN'], 'department-of-veterans-affairs/vets-api', 1
        )[:objects]

        assert_kind_of Array, all_workflow_runs
        assert_not_nil all_workflow_runs.first.github.workflow_id
      end
    end

    test 'lists all workflow runs for a branch on a repository' do
      VCR.use_cassette('github/workflow_run', record: :new_episodes) do
        branch_runs = Github::WorkflowRun.all_for_branch(
          ENV['GITHUB_ACCESS_TOKEN'], 'department-of-veterans-affairs/vets-api', 1, 'master'
        )[:objects]

        assert_kind_of Array, branch_runs
        assert_not_nil branch_runs.first.github.workflow_id
        assert_equal 'master', branch_runs.first.github.head_branch
      end
    end

    test 'lists all workflow runs for a given workflow' do
      VCR.use_cassette('github/workflow_run', record: :new_episodes) do
        workflow_runs = Github::WorkflowRun.all_for_workflow(
          ENV['GITHUB_ACCESS_TOKEN'], 'department-of-veterans-affairs/vets-api', 1, '13418388'
        )[:objects]

        assert_kind_of Array, workflow_runs
        assert_equal 13_418_388, workflow_runs.first.github.workflow_id
      end
    end
  end
end
