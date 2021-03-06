# frozen_string_literal: true

require 'test_helper'

module Github
  class RepositoryTest < ActiveSupport::TestCase
    setup do
      VCR.use_cassette('github/repository') do
        @repository = Github::Repository.new(
          ENV['GITHUB_ACCESS_TOKEN'], 'department-of-veterans-affairs/platform-console-api'
        )
      end
    end

    test 'can be created with a valid repository' do
      VCR.use_cassette('github/repository', record: :new_episodes) do
        assert_instance_of Github::Repository, @repository
        assert_instance_of Sawyer::Resource, @repository.github
        assert_equal 'platform-console-api', @repository.github.name
      end
    end

    test 'cannot be created with an invalid repository' do
      VCR.use_cassette('github/invalid_repository', record: :new_episodes) do
        assert_raises Octokit::NotFound do
          Github::Repository.new(ENV['GITHUB_ACCESS_TOKEN'], 'invalid-user/invalid-repository').github
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
        pull_requests = @repository.pull_requests[:objects]
        assert_kind_of Array, pull_requests
        assert_not_nil pull_requests.first.github.number
      end
    end

    test 'lists workflows for the repository' do
      VCR.use_cassette('github/repository', record: :new_episodes) do
        workflows = @repository.workflows[:objects]
        assert_kind_of Array, workflows
        assert_not_nil workflows.first.github.state
      end
    end

    test 'lists workflow runs for the repository' do
      VCR.use_cassette('github/repository', record: :new_episodes) do
        all_workflow_runs = @repository.workflow_runs[:objects]
        assert_kind_of Array, all_workflow_runs
        assert_not_nil all_workflow_runs.first.github.run_number
      end
    end

    test 'lists workflow runs for a given branch in the repository' do
      VCR.use_cassette('github/repository', record: :new_episodes) do
        branch_workflow_runs = @repository.branch_workflow_runs('master')[:objects]
        assert_kind_of Array, branch_workflow_runs
        assert_equal 'master', branch_workflow_runs.first.github.head_branch
      end
    end

    test 'lists workflow runs for a given workflow in the repository' do
      VCR.use_cassette('github/repository', record: :new_episodes) do
        workflow_runs = @repository.workflow_run('17962379')[:objects]
        assert_kind_of Array, workflow_runs
        assert_equal 17_962_379, workflow_runs.first.github.workflow_id
      end
    end

    test 'lists all repositories in the organization' do
      VCR.use_cassette('github/repository', record: :new_episodes) do
        org_repos = Github::Repository.all(ENV['GITHUB_ACCESS_TOKEN'])[:repositories]
        assert_kind_of Array, org_repos
      end
    end

    test 'creates a deploy pull request' do
      VCR.use_cassette('github/repository') do
        pull_request = @repository.create_deploy_workflow_pr
        assert_kind_of Sawyer::Resource, pull_request
        assert_equal 'Add deploy-template_demo.yml workflow file', pull_request.title
      end
    end
  end
end
