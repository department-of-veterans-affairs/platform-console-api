# frozen_string_literal: true

require 'test_helper'

module Github
  class RepositoryTest < ActiveSupport::TestCase
    setup do
      VCR.use_cassette('github/repository') do
        @repository = Github::Repository.new('vets-api')
      end
    end

    test 'can be created with a valid repository' do
      assert_instance_of Github::Repository, @repository
      assert_instance_of Sawyer::Resource, @repository.github
      assert_equal 'vets-api', @repository.github.name
    end

    test 'cannot be created with an invalid repository' do
      VCR.use_cassette('github/invalid_repository') do
        assert_raises Octokit::NotFound do
          Github::Repository.new('invalid-repository')
        end
      end
    end

    test 'lists issues for the repository' do
      VCR.use_cassette('github/repository', record: :new_episodes) do
        issues = @repository.issues[:issues]
        assert_kind_of Array, issues
        assert_not_nil issues.first.number
      end
    end

    test 'lists pull requests for the repository' do
      VCR.use_cassette('github/repository', record: :new_episodes) do
        pull_requests = @repository.pull_requests[:pull_requests]
        assert_kind_of Array, pull_requests
        assert_not_nil pull_requests.first.number
      end
    end

    test 'lists workflows for the repository' do
      VCR.use_cassette('github/repository', record: :new_episodes) do
        workflows = @repository.workflows.workflows
        assert_kind_of Array, workflows
        assert_not_nil workflows.first.state
      end
    end

    test 'lists workflow runs for the repository' do
      VCR.use_cassette('github/repository', record: :new_episodes) do
        all_workflow_runs = @repository.workflow_runs.workflow_runs
        assert_kind_of Array, all_workflow_runs
        assert_not_nil all_workflow_runs.first.run_number
      end
    end

    test 'lists workflow runs for a given branch in the repository' do
      VCR.use_cassette('github/repository', record: :new_episodes) do
        branch_workflow_runs = @repository.branch_workflow_runs('master').workflow_runs
        assert_kind_of Array, branch_workflow_runs
        assert_equal 'master', branch_workflow_runs.first.head_branch
      end
    end

    test 'lists workflow runs for a given workflow in the repository' do
      VCR.use_cassette('github/repository', record: :new_episodes) do
        workflow_runs = @repository.workflow_run('13418388').workflow_runs
        assert_kind_of Array, workflow_runs
        assert_equal 13_418_388, workflow_runs.first.workflow_id
      end
    end

    test 'lists all repositories in the organization' do
      VCR.use_cassette('github/repository', record: :new_episodes) do
        org_repos = Github::Repository.all[:repositories]
        assert_kind_of Array, org_repos
      end
    end
  end
end
