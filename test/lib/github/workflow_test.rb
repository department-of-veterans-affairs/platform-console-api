# frozen_string_literal: true

require 'test_helper'

module Github
  class WorkflowTest < ActiveSupport::TestCase
    setup do
      VCR.use_cassette('github/workflow') do
        @workflow = Github::Workflow.new(
          ENV['GITHUB_ACCESS_TOKEN'], 'department-of-veterans-affairs/vets-api', '13418388'
        )
      end
    end

    test 'can be created with a valid repo and workflow id' do
      VCR.use_cassette('github/workflow', record: :new_episodes) do
        assert_instance_of Github::Workflow, @workflow
        assert_instance_of Sawyer::Resource, @workflow.github
        assert_equal 13_418_388, @workflow.github.id
      end
    end

    test 'lists all runs for the workflow' do
      VCR.use_cassette('github/workflow', record: :new_episodes) do
        workflow_runs = @workflow.workflow_runs.workflow_runs
        assert_equal 13_418_388, workflow_runs.first.workflow_id
      end
    end

    test 'lists all workflows for the given repository' do
      VCR.use_cassette('github/workflow', record: :new_episodes) do
        workflows = Github::Workflow.all(
          ENV['GITHUB_ACCESS_TOKEN'], 'department-of-veterans-affairs/vets-api'
        ).workflows
        assert_kind_of Array, workflows
        assert_not_nil workflows.first.state
      end
    end

    test 'dispatch a workflow' do
      VCR.use_cassette('github/workflow', record: :new_episodes) do
        dispatch = Github::Workflow.dispatch!(
          ENV['GITHUB_ACCESS_TOKEN'], 'department-of-veterans-affairs/platform-console-api', 17_929_736, 'master'
        )
        assert dispatch
      end
    end
  end
end
