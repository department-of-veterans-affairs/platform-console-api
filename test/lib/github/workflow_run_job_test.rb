# frozen_string_literal: true

require 'test_helper'

module Github
  class WorkflowRunJobTest < ActiveSupport::TestCase
    setup do
      VCR.use_cassette('github/workflow_run_job') do
        @workflow_run_job = Github::WorkflowRunJob.new('vets-api', 5_169_530_176)
      end
    end

    test 'can be created with a valid repo and workflow_run_job id' do
      assert_instance_of Github::WorkflowRunJob, @workflow_run_job
      assert_instance_of Sawyer::Resource, @workflow_run_job.github
      assert_equal 5_169_530_176, @workflow_run_job.id
    end

    test 'get logs' do
      logs = @workflow_run_job.logs
      assert_kind_of String, logs
    end

    test 'get logs returns check-run results when logs do not exist' do
      VCR.use_cassette('github/workflow_run_job', record: :new_episodes) do
        workflow_run_job = Github::WorkflowRunJob.new('vets-api', 5_204_164_825)
        logs = workflow_run_job.logs
        assert_kind_of String, logs
      end
    end

    test 'lists all workflow run jobs for a workflow run' do
      VCR.use_cassette('github/workflow_run_job', record: :new_episodes) do
        all_workflow_run_jobs = Github::WorkflowRunJob.all_for_workflow_run('vets-api', 1_834_786_549).jobs
        assert_kind_of Array, all_workflow_run_jobs
        assert_not_nil all_workflow_run_jobs.first.run_id
      end
    end
  end
end
