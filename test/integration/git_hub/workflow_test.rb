# frozen_string_literal: true

require 'test_helper'

module GitHub
  class WorkflowTest < ActionDispatch::IntegrationTest
    setup do
      VCR.use_cassette('git_hub/workflow') do
        @workflow = GitHub::Workflow.new('vets-api', '13418388')
      end
    end

    test 'can be created with a valid repo and workflow id' do
      assert_instance_of GitHub::Workflow, @workflow
      assert_instance_of Sawyer::Resource, @workflow.gh_info
      assert_equal 13_418_388, @workflow.gh_info.id
    end

    test 'lists all runs for the workflow' do
      VCR.use_cassette('git_hub/workflow', record: :new_episodes) do
        workflow_runs = @workflow.runs.workflow_runs
        assert_equal 13_418_388, workflow_runs.first.workflow_id
      end
    end

    test 'lists all workflows for the given repository' do
      VCR.use_cassette('git_hub/workflow', record: :new_episodes) do
        workflows = GitHub::Workflow.all('vets-api').workflows
        assert_kind_of Array, workflows
        assert_not_nil workflows.first.state
      end
    end
  end
end
